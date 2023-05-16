function theme_precmd {
    # Pretty up the current directory
    dirs -c ;
    local FULL=$(dirs | awk -F '/' '
    {
        if($1 == "")
        {
            if (NF > 5) {
                print "/"$2"/.../"$(NF-2)"/"$(NF-1)"/"$NF
            } 
            else { 
                print $(dirs) 
            }
        }
        else
        {
            if (NF > 3) 
            {
                print $1"/.../"$(NF-2)"/"$(NF-1)"/"$NF
            } 
            else { 
                print $(dirs) 
            }
        }
    }') ;
    DIR_END=$(basename $(dirs)) ;
    DIR_PRE=${FULL%${DIR_END}} ;
    if [[ $DIR_END = "" ]] ; then
        DIR_END=$DIR_PRE ;
        DIR_PRE='' ;
    fi ;
    STATUS="$BLUE⠒%(?.$GREEN✓.$RED✗)$BLUE⠒

" ;
    
    # Last status only if the terminal isn't new or cleared.
    local ELAPSED=$(ps -p $$ -o etimes | awk 'FNR>1{print $1}') ;
    local HISTORY=$(echo $(history -1) | sed 's/[^ ]* //') ;
    if [[ $ELAPSED -le 1 || $HISTORY = "clear" ]] ; then
        STATUS="" ;
    fi ;
}

setopt prompt_subst

autoload zsh/terminfo
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
  typeset -g $color="%{$terminfo[bold]$fg[${(L)color}]%}"
  typeset -g LIGHT_$color="%{$fg[${(L)color}]%}"
done

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd

ZSH_THEME_GIT_PROMPT_PREFIX="$BLUE""⠒[""$MAGENTA"
ZSH_THEME_GIT_PROMPT_SUFFIX="$BLUE""]⠒%f"
ZSH_THEME_GIT_PROMPT_DIRTY="$YELLOW""·"
ZSH_THEME_GIT_PROMPT_CLEAN=""


PROMPT='$STATUS\
🐺${BLUE} ⠒\
${BLUE}[${YELLOW}%(!.%SROOT%s.%n)${CYAN}@%m${BLUE}]⠒\
${BLUE}[${CYAN}${DIR_PRE}${YELLOW}${DIR_END}${BLUE}]⠒\

 ${YELLOW}%B↳%b%f '

RPROMPT='$(git_prompt_info)'