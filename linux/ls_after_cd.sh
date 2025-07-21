# Do automatically an `eza` after every successfull cd:

function cd {
    builtin cd "$@" && eza
}

# Go up n levels:

# Usage .. [n]
function .. (){
    local arg=${1:-1};
    local dir=""
    while [ $arg -gt 0 ]; do
        dir="../$dir"
        arg=$(($arg - 1));
    done
    cd $dir #>&/dev/null
}
