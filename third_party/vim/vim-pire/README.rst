================================================================================
                          vim-pire colorscheme
================================================================================

Dark/light colorscheme for vim.

Based on palette of quiet__ (@neutaaaaan).

__ https://github.com/vim/colorschemes/blob/master/colortemplate/quiet.colortemplate

Dark has black and light has white backgrounds, all the colors are from standard
256 palette:

.. image:: https://user-images.githubusercontent.com/234774/199482850-7ce2e0aa-5165-4880-9142-45c3a23cb39d.png
.. image:: https://user-images.githubusercontent.com/234774/199482927-5685a448-422f-49f1-ab6b-e19d82775778.png

With the following in your vimrc, it might look a bit different:

.. code::

  def RePire()
      if &background == 'dark'
          hi Normal      ctermbg=NONE guibg=#1c1c1c
          hi TablineSel  ctermbg=NONE guibg=#1c1c1c
          hi Folded      ctermbg=233  guibg=#121212
          hi Cursorline  ctermbg=236  guibg=#303030
          hi Pmenu       ctermbg=236  guibg=#303030
          hi ColorColumn ctermbg=233  guibg=#121212
      else
          hi Normal       guibg=#f7f7f0
          hi TablineSel   guifg=#f7f7f0
          hi Tabline      guifg=#444444 guibg=#d7d7d0
          hi StatusLineNC guifg=#444444 guibg=#d7d7d0
          hi StatusLine   guibg=#5f5f5f gui=NONE
          hi Cursorline   guibg=#e7e7e0
          hi Folded       guibg=#fffff9
          hi ColorColumn  guibg=#fffff9
      endif
  enddef

  augroup colorschemes | au!
      au Colorscheme pire RePire()
  augroup END

  set background=dark
  set termguicolors
  silent! colorscheme pire


.. image:: https://user-images.githubusercontent.com/234774/199991009-65e7f585-cfdc-4932-aa72-5b08f823e2d3.png
.. image:: https://user-images.githubusercontent.com/234774/199991052-de8e8db5-982b-43aa-8ace-0a9993982963.png
