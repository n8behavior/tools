################################################################################
# log LEVEL MESSAGE
#   LEVEL   - Should be one of ERROR, WARNING, INFO, DEBUG
#   MESSAGE - Log message or any BASH expression
#
# Writes a log message to sterr along with a call stack strace
################################################################################
log()
{
    LEVEL=$1
    MSG=$2
    CALL_STACK=$(
    local i=0
    while caller $i
    do
        ((i++))
    done
    )
    STACK_TRACE=$(
    while read frame
    do
        echo -e "  ...at line $frame"
    done <<<"$CALL_STACK"
    )
    echo -e "[$LEVEL] $MSG\n$STACK_TRACE" >&2
}

################################################################################
# assert EXPR1 EXPR2
#   EXPR    - Any BASH expression
#
# Tests two expressions for equality
################################################################################
assert()
{
    retval="$($1)" ||
        {
            log ERROR "Call to '$1' failed"
            return 1
        }
        [[ $retval == $2 ]] || 
        {
            log FAIL "called '$1' and expected '$2' but got '$retval'."
            return 1
        }
    }
