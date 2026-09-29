"""Claude Code PreToolUse guard. Run only via guard.sh (system python3, -I -S).

Allow only when certain, ask on any uncertainty, deny on funny business.
No output = no opinion, normal permission flow. Any exception exits non-zero;
guard.sh turns that into a block (fail closed). Stdlib only.

Pipeline for Bash: shlex tokenize (quotes resolved, quoted scripts re-split),
regex/set matching on tokens, realpath on anything path-shaped. Nothing is executed.
"""
import json
import os
import re
import shlex
import sys

FILE_TOOLS = {"Read", "Glob", "Grep", "Edit", "Write", "NotebookEdit"}
WRITE_TOOLS = {"Edit", "Write", "NotebookEdit"}
SAFE_DEVICES = {"/dev/null", "/dev/stdin", "/dev/stdout", "/dev/stderr"}
STREAM_DEVICES = {"/dev/zero", "/dev/random", "/dev/urandom", "/dev/tty"}  # endless: ask
SYSTEM_DIRS = ("/etc", "/usr", "/bin", "/sbin", "/boot", "/lib", "/lib64", "/var",
               "/proc", "/sys", "/root", "/run", "/System", "/Library", "/private")
OPERATORS = {"&&", "||", ";", "|", "|&", "&"}
# Shell keywords: transparent when finding the command word of a segment.
KEYWORDS = {"if", "then", "else", "elif", "fi", "do", "done", "while", "until", "for", "in",
            "case", "esac", "function", "{", "}", "(", ")", "!"}

# Bash commands the hook will explicitly allow when every path is inside cwd/memory
# and the command is a single plain segment with no globs.
READ_ONLY_CMDS = {"ls", "cat", "head", "tail", "wc", "stat", "grep", "diff", "du",
                  "realpath", "readlink", "pwd"}
FOLLOW_FLAG = re.compile(r"^-[a-zA-Z]*[fF]|^--follow")  # tail -f / -fn / --follow=name never returns

# File names that are never OK to read or touch, anywhere, cwd included.
SENSITIVE_FILES = re.compile(
    r"(^|/)(\.ssh|\.aws|\.gnupg|\.kube|\.azure|\.docker|gcloud|\.config/gh|\.password-store)(/|$)"
    r"|(^|/)(id_rsa|id_ed25519|id_ecdsa|id_dsa|authorized_keys|known_hosts)(\.|$)"
    r"|(^|/)(shadow|gshadow|sudoers|\.netrc|\.npmrc|\.pypirc|\.pgpass|\.my\.cnf|\.boto|\.s3cfg"
    r"|\.htpasswd|\.git-credentials|\.credentials\.json|\.claude\.json|\.vault-token"
    r"|\.lesshst|\.viminfo)$"
    r"|_history$|\.history$|histfile"
    r"|\.env(\.[\w-]+)?$|\.(pem|key|p12|pfx|jks|keystore|der|gpg|pgp|kdbx|ovpn|tfstate|token)$"
    r"|(^|/)environ$",
    re.IGNORECASE,
)
# Substring words: deny outside cwd. Inside cwd the permission deny rules decide, so a
# project named keyring-tools or a file named secrets.py is not the hook's business.
SENSITIVE_WORDS = re.compile(
    r"credential|secret|password|passwd|api[_-]?key|private[_-]?key|service[_-]?account|keyring|wallet",
    re.IGNORECASE)
# Shell variable expansions whose name smells like a secret, code that reads the env,
# and anything touching shell history configuration.
SECRET_VAR = re.compile(
    r"\$\{?!?[A-Za-z_]*(KEY|TOKEN|SECRET|PASS|CRED|AUTH|PRIVATE|ACCESS|SESSION|COOKIE|CERT|SIGN)"
    r"|\benviron\b|\bgetenv\b"
    r"|HIST(FILE|SIZE|CONTROL|IGNORE|FILESIZE|APPEND|VERIFY|REEDIT)|SAVEHIST", re.IGNORECASE)
ENV_DUMP = {"env", "printenv", "set", "export", "declare", "typeset", "compgen"}
# Denied wherever the word appears: nested scripts, arguments, comments included.
DENY_CMDS = {
    "sudo", "sudoedit", "su", "doas", "pkexec", "runuser", "chroot", "nsenter", "unshare",
    "setpriv", "capsh",
    "ssh", "mosh", "ssh-add", "ssh-keygen", "ssh-agent", "ssh-copy-id", "gpg", "gpg2", "fc",
    "history",  # also catches `set +o history`
    "shutdown", "reboot", "halt", "poweroff", "telinit",
    "crontab", "visudo", "passwd", "chpasswd", "useradd", "usermod", "userdel",
    "iptables", "ip6tables", "nft", "firewall-cmd", "ufw", "pfctl",
    "setenforce", "setsebool", "semanage", "aa-teardown", "aa-complain", "aa-disable", "auditctl",
    "modprobe", "insmod", "rmmod", "kextload", "kextunload", "csrutil", "spctl", "nvram",
    "fdisk", "sfdisk", "cfdisk", "gdisk", "sgdisk", "parted", "diskutil", "wipefs", "mkswap",
    "swapon", "swapoff", "losetup", "chattr", "shred", "mkfifo",
    "launchctl", "systemctl",
}
# Denied only as the first word of a segment: ordinary words or common arguments
# otherwise (git init, "fix bug at line 3", "security fix").
FIRST_WORD_DENY = {"init", "at", "batch", "op", "security", "keychain", "vault",
                   "mount", "umount"}
ASK_CMDS = {
    "sh", "bash", "zsh", "dash", "ksh", "fish", "source", "git", "xargs",
    "apt", "apt-get", "dnf", "yum", "pacman", "zypper", "apk", "brew", "gem", "pipx",
    "poetry", "bundle", "pdm",
    # wrappers: otherwise they become the first word and hide what they run
    "command", "builtin", "nice", "ionice", "chrt", "taskset", "timeout", "watch", "stdbuf",
    "flock", "time",
    # interpreters that can exec
    "awk", "gawk", "mawk", "nawk", "sed", "php", "lua", "luajit", "tclsh", "rscript", "deno",
    "bun", "ts-node", "tsx", "julia",
    "kill", "killall", "pkill", "defaults", "service", "sysctl", "shopt",
    "chmod", "chown", "chgrp", "dd", "truncate", "eval", "exec", "nohup", "setsid",
    "curl", "wget", "nc", "ncat", "netcat", "scp", "sftp", "rsync", "ftp", "telnet", "socat",
    "python", "python2", "python3", "pip", "pip3", "pytest", "uv", "conda", "perl", "ruby",
    "node", "npm", "npx", "make", "cmake", "ninja", "gcc", "g++", "cc", "c++", "clang",
    "clang++", "nvcc", "ld", "cargo", "go", "mvn", "gradle", "bazel", "ctest", "lit",
}
# Raw-string regexes.
CRED_CMDS = re.compile(
    r"\bgh auth\b|\baws (configure|sts|secretsmanager)\b|\bgcloud auth\b|\bkubectl .*\bsecrets?\b"
    r"|\bdocker login\b|\bnpm token\b|\bpass (show|ls)\b|\bsecurity find-")
NET_TOOLS = re.compile(
    r"\b(curl|wget|nc|ncat|netcat|socat|scp|sftp|rsync|ssh|ftp|telnet|base64|xxd|openssl)\b")
PIPE_TO_SHELL = re.compile(
    r"\|\s*(sudo\s+)?((ba|z|da|k)?sh|fish|python[\d.]*|perl|ruby|node)\b")
PROC_SUBST_NET = re.compile(r"<\(\s*(curl|wget)\b")  # bash <(curl x)
DESTRUCTIVE = re.compile(
    r"--no-preserve-root|\bmkfs\b|\bdd\b.*\bof=/dev/|:\(\)\s*\{.*:\|:"
    r"|(\w+)\s*\(\)\s*\{[^}]{0,200}\b\1\s*\|\s*\1\s*&"   # named fork bomb: f(){ ... f|f& }
    r"|>\s*/dev/(sd|nvme|disk|hd|mmcblk)|\bchmod\b.*\b777\b.*\s/(\s|$)")
REVSHELL = re.compile(
    r"/dev/(tcp|udp)/|\b(nc|ncat|netcat)\b[^|;&]*\s(-[a-zA-Z]*[ce]\b|--(sh-)?exec)"
    r"|\bsocat\b.*\bexec:|\bbash\s+-i\b", re.IGNORECASE)
FUNC_DEF = re.compile(r"\b\w+\s*\(\)\s*\{")
NON_ASCII = re.compile(r"[^\x00-\x7f]")
RM_FORCE_OR_RECURSIVE = re.compile(r"^-[a-zA-Z]*[rRf]|^--(recursive|force)$")
# Token regexes.
SUBST_EDGES = re.compile(r"^[$<>]?\(|^`|[`)]+$")   # $(cmd, <(cmd, `cmd`, cmd)
REDIRECT = re.compile(r"^\d*[<>&|]")               # 2>&1, >/dev/null, &&, |
SEPARATORS = re.compile(r"(\|\||&&|\|&|[;|&<>]+)")  # glued: "a;b", "a|b", "x>file"
GLOB_CHARS = re.compile(r"[*?\[]")
ASSIGN = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*=")
BIN_PREFIX = re.compile(r"^/(usr/(local/)?)?s?bin/")  # /bin/rm -> rm, for name matching only
URL = re.compile(r"^\w+://")


def decide(decision, reason):
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": decision,
        "permissionDecisionReason": reason,
    }}))
    sys.exit(0)


def within(path, root):
    root = root.rstrip("/")
    if not root:
        return True  # root is "/": everything is under it
    return path == root or path.startswith(root + "/")


class Zones:
    def __init__(self, data):
        self.cwd = os.path.realpath(data["cwd"])
        self.home = os.path.realpath(os.path.expanduser("~"))
        self.safe = [self.cwd]
        # Same dirs as written (unresolved), for comparing against written paths: Claude
        # spells in-repo paths with the cwd it was given, which may itself go through a
        # symlink and differ from the realpath.
        self.safe_raw = [os.path.normpath(data["cwd"])]
        if data.get("scratchpad_dir"):
            self.safe.append(os.path.realpath(data["scratchpad_dir"]))
            self.safe_raw.append(os.path.normpath(data["scratchpad_dir"]))
        # Memory: global (readable, writes ask) and project-local (the only writable one).
        # Each dir plus the MEMORY.md index that sits next to it.
        self.global_memory = [os.path.realpath(os.path.expanduser("~/.claude/memory")),
                              os.path.realpath(os.path.expanduser("~/.claude/MEMORY.md"))]
        self.project_memory = []
        if data.get("transcript_path"):
            project_dir = os.path.realpath(os.path.dirname(data["transcript_path"]))
            self.project_memory = [os.path.join(project_dir, "memory"),
                                   os.path.join(project_dir, "MEMORY.md")]
        self.memory = self.global_memory + self.project_memory
        self.config = [os.path.realpath(os.path.expanduser(p)) for p in (
            "~/.claude/settings.json", "~/.claude/settings.local.json",
            "~/.claude/hooks", "~/.claude.json")]
        # Writes anywhere under these always ask, whatever the mode or cwd.
        self.home_raw = os.path.expanduser("~")
        self.guarded = [os.path.realpath(os.path.expanduser("~/.dotfiles")),
                        os.path.realpath(os.path.expanduser("~/.claude"))]
        self.claude_raw = os.path.normpath(os.path.expanduser("~/.claude"))

    def resolve(self, raw):
        return os.path.realpath(os.path.join(self.cwd, os.path.expanduser(raw)))

    def requested(self, raw):
        """The path as written, normalized, symlinks NOT resolved. Relative paths are
        joined onto the cwd as written. normpath keeps a leading //, collapse it."""
        req = os.path.normpath(os.path.join(self.safe_raw[0], os.path.expanduser(raw)))
        return re.sub(r"^/+", "/", req)

    def requested_inside(self, raw):
        """Written path under a safe dir, by either spelling? Claude Code's own
        outside-working-dir check looks at the written path, so a symlink like
        ~/.claude/MEMORY.md -> <cwd>/... needs an explicit allow from us."""
        req = self.requested(raw)
        return any(within(req, s) for s in self.safe + self.safe_raw)

    def requested_home_dot(self, raw):
        """Written path is ~/.something and not inside cwd. A cwd of ~/.dotfiles makes
        every absolute in-repo path start with ~/.dotfiles; those are plain cwd paths."""
        if self.requested_inside(raw):
            return False
        rel = os.path.relpath(self.requested(raw), self.home_raw)
        return not rel.startswith("..") and rel.split("/")[0].startswith(".")

    def is_project_memory(self, real):
        return any(within(real, p) for p in self.project_memory)

    def is_memory(self, real):
        """Global or project memory by realpath. Not via zone: inside a dotfiles cwd the
        zone is 'safe', but the ~/.x read rule must still not fire on memory."""
        return any(within(real, m) for m in self.memory)

    def is_guarded(self, raw, real):
        """Under ~/.dotfiles or ~/.claude by realpath, or written as ~/.claude/..."""
        return (any(within(real, g) for g in self.guarded)
                or within(self.requested(raw), self.claude_raw))

    def classify(self, raw):
        """Return (zone, realpath). Inside cwd is always 'safe'."""
        if raw in SAFE_DEVICES or raw.startswith("/dev/fd/"):
            return "devnull", raw
        if raw in STREAM_DEVICES:
            return "outside", raw
        if raw.startswith("/dev/"):
            return "device", raw
        real = self.resolve(raw)
        if SENSITIVE_FILES.search(raw) or SENSITIVE_FILES.search(real):
            return "sensitive", real
        if any(within(real, s) for s in self.safe):
            return "safe", real
        if SENSITIVE_WORDS.search(raw) or SENSITIVE_WORDS.search(real):
            return "sensitive", real
        if any(within(real, m) for m in self.memory):
            return "memory", real
        if any(within(real, c) for c in self.config):
            return "config", real
        if any(within(real, d) for d in SYSTEM_DIRS):
            return "system", real
        rel = os.path.relpath(real, self.home)
        if not rel.startswith("..") and rel.split("/")[0].startswith("."):
            return "home_dot", real
        return "outside", real

    def critical(self, real):
        """Targets whose removal is never OK."""
        return (real in ("/", self.home, self.cwd)
                or os.path.dirname(real) == "/"
                or within(self.cwd, real))


def check_file_tool(tool, inp, zones, mode):
    raw = inp.get("file_path") or inp.get("notebook_path") or inp.get("path")
    if raw is None:
        if tool in ("Glob", "Grep"):
            raw = "."
        else:
            decide("ask", tool + ": no path in input")
    if "$" in raw or "`" in raw:
        decide("ask", "unresolvable path: " + raw)
    pattern = inp.get("pattern", "")
    if tool == "Glob" and (pattern.startswith(("/", "~")) or ".." in pattern):
        decide("ask", "Glob pattern escapes search dir: " + pattern)
    file_glob = inp.get("glob") or ""
    if tool == "Grep" and SENSITIVE_FILES.search(file_glob):
        decide("deny", "Grep glob targets sensitive files: " + file_glob)
    zone, real = zones.classify(raw)
    if zone in ("sensitive", "device"):
        decide("deny", zone + " path: " + real)

    if tool in WRITE_TOOLS:
        # The hook never allows a write. Silent only where the mode may auto-approve.
        if zone in ("config", "system"):
            decide("deny", "write to " + zone + ": " + real)
        if zones.is_project_memory(real):
            if mode == "acceptEdits":
                return
            decide("ask", "write to project memory: " + real)
        if zones.is_guarded(raw, real) or zone == "memory":
            decide("ask", "write under ~/.dotfiles or ~/.claude: " + real)
        if zone == "home_dot" or zones.requested_home_dot(raw):
            decide("deny", "write to ~/.* outside dotfiles: " + real)
        if zone in ("safe", "devnull"):
            if mode == "acceptEdits":
                return
            decide("ask", "write needs approval: " + real)
        decide("ask", "write outside working dir: " + real)

    # Reads.
    if zones.is_memory(real):
        decide("allow", "memory: " + real)
    if zones.requested_home_dot(raw):
        decide("ask", "read of ~/.*: " + real)  # even when it resolves into cwd
    if zone == "safe" and not zones.requested_inside(raw):
        decide("allow", "resolves inside cwd: " + real)
    if zone in ("safe", "devnull"):
        return
    decide("ask", "outside working dir: " + real)


def tokens_of(command):
    """Bag of words. Quotes removed, quoted scripts re-split, substitution edges
    stripped so `$(rm` becomes `rm`, glued separators split so `c=rm;` becomes
    `c=rm` `;`. Redirect/pipe operator tokens are kept whole. Comments are not
    stripped: a comment containing a denied word still denies."""
    try:
        toks = shlex.split(command, posix=True)
    except ValueError:
        decide("ask", "unparseable shell command")
    out = []
    for tok in toks:
        tok = re.sub(r"=[$<>]?\(", "= ", tok)  # X=$(sudo ls) -> "X=" "sudo" ...
        if any(ch.isspace() for ch in tok):
            out.extend(tokens_of(tok))  # nested script: bash -c "...", python -c "..."
            continue
        tok = SUBST_EDGES.sub("", tok)
        if REDIRECT.match(tok):
            out.append(tok)
            continue
        out.extend(part for part in SEPARATORS.split(tok) if part)
    return out


def first_words(names):
    """The word at the start and after each operator, skipping VAR=val prefixes."""
    words = []
    at_start = True
    for name in names:
        if name in OPERATORS:
            at_start = True
        elif at_start and not ASSIGN.match(name) and name not in KEYWORDS:
            words.append(name)
            at_start = False
    return words


def path_candidates(tokens):
    cands = set()
    for tok in tokens:
        tok = re.sub(r"^\d*[<>&|]+", "", tok)
        if "=" in tok:
            tok = tok.split("=", 1)[1]
        parts = tok.split(":") if tok.startswith(("/", "~")) else [tok]
        for part in parts:
            if part.startswith(("/", "~", "./", "../")) or part in (".", ".."):
                cands.add(part)
            elif "/" in part and not URL.match(part):
                cands.add(part)
    return cands


def check_rm(names, tokens, zones):
    """rm -f / -r: always deny, left to the user. Plain rm/rmdir/unlink: ask."""
    for i, name in enumerate(names):
        if name not in ("rm", "rmdir", "unlink"):
            continue
        targets = []
        for j in range(i + 1, len(names)):
            if names[j] in OPERATORS:
                break
            if names[j].startswith("-"):
                if name == "rm" and RM_FORCE_OR_RECURSIVE.match(names[j]):
                    decide("deny", "rm -f/-r is left to the user: " + names[j])
                continue
            targets.append(tokens[j])
        for arg in targets:
            if "$" in arg or "`" in arg:
                decide("deny", "rm with variable target: " + arg)
            zone, real = zones.classify(arg)
            if zones.critical(real):
                decide("deny", "rm on critical path: " + real)
            if zone != "safe":
                decide("deny", "rm outside cwd: " + real)
        decide("ask", name + ": deletion needs user approval")


def check_env_dump(names):
    """Whole-environment dumps: deny. Reading one named variable: ask."""
    for i, name in enumerate(names):
        if name not in ENV_DUMP:
            continue
        args = []
        for arg in names[i + 1:]:
            if arg in OPERATORS:
                break
            args.append(arg)
        if name in ("env", "printenv"):
            vars_ = [a for a in args if "=" not in a and not a.startswith("-")]
            if vars_ and name == "env":
                continue  # wrapper form: env X=1 cmd; cmd is checked like any other token
            if not vars_:
                decide("deny", "environment dump: " + name)
            if any(SECRET_VAR.search("$" + v) or SENSITIVE_WORDS.search(v) for v in vars_):
                decide("deny", "secret-looking env var: " + " ".join(vars_))
            decide("ask", "read env var: " + " ".join(vars_))
        elif name == "set":
            if not args:
                decide("deny", "environment dump: set")
        elif name in ("export", "declare", "typeset"):
            if all(a.startswith("-") for a in args):
                decide("deny", "environment dump: " + name)
        elif name == "compgen":
            if {"-v", "-e", "-A"} & set(args):
                decide("deny", "environment dump: compgen")


def simple_read_only(names):
    """One plain read-only command, no operators/redirects. Paths already verified
    inside allowed zones by the caller."""
    if not names or names[0] not in READ_ONLY_CMDS:
        return False
    for name in names:
        if name in OPERATORS or REDIRECT.match(name) or GLOB_CHARS.search(name):
            return False  # a glob could expand to .env, .npmrc, ...
        if names[0] == "tail" and FOLLOW_FLAG.match(name):
            return False
    return True


def check_bash(command, zones):
    if not command.strip():
        decide("ask", "empty command")
    if len(command) > 20000:
        decide("ask", "command longer than 20000 chars")
    if NON_ASCII.search(command):
        decide("ask", "non-ASCII characters in command")
    command = command.replace("\\\n", "")   # shell line continuation: r\<nl>m -> rm
    command = command.replace("\n", " ; ")  # newline separates commands
    if DESTRUCTIVE.search(command):
        decide("deny", "destructive pattern")
    if REVSHELL.search(command):
        decide("deny", "reverse shell pattern")
    if CRED_CMDS.search(command):
        decide("deny", "credential extraction command")
    if (PIPE_TO_SHELL.search(command) or PROC_SUBST_NET.search(command)) \
            and NET_TOOLS.search(command):
        decide("deny", "remote content piped to interpreter")

    tokens = tokens_of(command)
    # Names for matching, lowercased (case-insensitive filesystems run `Sudo`); tokens keep
    # their paths and case for zone checks. /bin/rm -> rm always; any other absolute path
    # whose basename is a denied command -> that name.
    names = []
    for tok in tokens:
        name = BIN_PREFIX.sub("", tok).lower()
        if name.startswith(("/", "~")) and name.rsplit("/", 1)[-1] in DENY_CMDS:
            name = name.rsplit("/", 1)[-1]
        names.append(name)
    heads = first_words(names)

    sens = sorted({t for t in tokens if SENSITIVE_FILES.search(t)})
    if sens:
        decide("deny", "sensitive file: " + ", ".join(sens[:3]))
    leaks = sorted({t for t in tokens if SECRET_VAR.search(t)})
    if leaks:
        decide("deny", "secret-looking variable, env access, or history config: "
               + ", ".join(leaks[:3]))
    check_env_dump(names)
    hit = (DENY_CMDS & set(names)) | (FIRST_WORD_DENY & set(heads))
    if hit:
        decide("deny", "privileged/system/credential command: " + ", ".join(sorted(hit)))
    for head in heads:
        if "$" in head or "`" in head:
            decide("deny", "variable or substitution in command position: " + head)
    check_rm(names, tokens, zones)

    asks = set(ASK_CMDS & set(names))
    if "env" in names:
        asks.add("env wrapper")  # bare env was already denied above; this is env X=1 cmd
    if names and names[0] == ".":
        asks.add("source")
    if "$(" in command or "`" in command:
        asks.add("command substitution")
    if FUNC_DEF.search(command):
        asks.add("function definition")
    if PIPE_TO_SHELL.search(command):
        asks.add("pipe to interpreter")
    if "&" in tokens:
        asks.add("background job")
    if "find" in names and {"-delete", "-exec", "-execdir", "-ok", "-okdir"} & set(names):
        asks.add("find with -delete/-exec")
    for tok in tokens:
        if "$" in tok or "`" in tok:
            asks.add("variable: " + tok)
        if "{" in tok and "}" in tok:
            asks.add("brace expansion: " + tok)
    read_only = simple_read_only(names)
    if not read_only and any(within(zones.cwd, g) for g in zones.guarded):
        asks.add("non-read-only command inside ~/.dotfiles or ~/.claude")
    for cand in path_candidates(tokens):
        if "$" in cand or "`" in cand:
            continue  # already asked above
        zone, real = zones.classify(cand)
        if zone in ("sensitive", "device"):
            decide("deny", zone + " path: " + real)
        if zones.is_memory(real):
            continue
        # Written as ~/.x or ~/.claude/...: only a plain read-only command may touch it,
        # and even that asks. Anything else is denied.
        if zones.requested_home_dot(cand) or within(zones.requested(cand), zones.claude_raw):
            if not read_only:
                decide("deny", "non-read-only command on ~/.* path: " + real)
            asks.add("read of ~/.* path: " + real)
            continue
        # Resolves under ~/.dotfiles or ~/.claude but written another way (e.g. inside a
        # dotfiles cwd): read-only inside cwd is fine, anything else asks.
        if zones.is_guarded(cand, real):
            if not read_only or zone not in ("safe", "devnull"):
                asks.add("touches ~/.dotfiles or ~/.claude: " + real)
            continue
        if zone in ("safe", "devnull"):
            continue
        asks.add("outside cwd: " + real)
    if asks:
        decide("ask", "; ".join(sorted(asks)[:6]))
    if read_only:
        decide("allow", "read-only command inside allowed dirs")


def main():
    data = json.loads(sys.stdin.buffer.read().decode("utf-8", "replace"))
    tool = data.get("tool_name", "")
    inp = data.get("tool_input") or {}
    mode = data.get("permission_mode") or ""
    zones = Zones(data)
    if within(zones.home, zones.cwd):
        # cwd is $HOME or an ancestor of it: every ~/.x would count as "inside cwd".
        decide("deny", "session cwd is HOME or above (" + zones.cwd + "); refusing all tools")
    if tool in FILE_TOOLS:
        check_file_tool(tool, inp, zones, mode)
    elif tool == "Bash":
        check_bash(inp.get("command", ""), zones)


if __name__ == "__main__":
    main()
