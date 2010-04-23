all: copyname.so sendtoall.so

copyname.so: copyname.c
	gcc  `pkg-config --cflags pidgin purple` \
		-DPURPLE_PLUGINS -DENABLE_NLS -DHAVE_ZLIB -shared -fPIC -DPIC \
		copyname.c  \
		-o copyname.so
sendtoall.so: sendtoall.c
	gcc  `pkg-config --cflags purple` \
		-DPURPLE_PLUGINS -DENABLE_NLS -DHAVE_ZLIB -shared -fPIC -DPIC \
		sendtoall.c  \
		-o sendtoall.so

	

	
