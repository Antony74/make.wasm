
    docker build -t akb74/make.wasm .
    docker run -it -v .:/build/host akb74/make.wasm

    weak int posix_spawn(pid_t *pid, const char *path,
                       const posix_spawn_file_actions_t *file_actions,
                       const posix_spawnattr_t *attrp,
                       char *const argv[], char *const envp[]) {
    errno = ENOSYS;
    return -1;
    }

    

    system\lib\libc\musl\src\unistd\getcwd.c

    vs

    system\lib\libc\emscripten_libc_stubs.c