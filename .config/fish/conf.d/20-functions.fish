# Git push with upstream
function gpsu
    set branch_name (git branch --show-current)
    git push -u origin $branch_name
end
