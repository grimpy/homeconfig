ab pdb import pdb;pdb.set_trace()
ab rpdb import rpdb2;rpdb2.start_embedded_debugger('test', fAllowRemote=True)
ab flacky # hghooks: no-pyflakes
let g:python = 'python2'
let g:pydoc = 'pydoc2'
set foldmethod=indent
set foldlevel=99
set omnifunc=pythoncomplete#Complete
set makeprg=nosetests2\ %
