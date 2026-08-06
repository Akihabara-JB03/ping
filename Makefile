make:
	gcc pingpong_main.c action.c \
	-IC:/vcpkg/installed/x64-windows/include \
	-LC:/vcpkg/installed/x64-windows/lib \
	-lraylib -lopengl32 -lgdi32 -lwinmm \
	-o pingpong.exe
