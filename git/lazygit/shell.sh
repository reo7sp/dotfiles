# ------------------------------------------------------------------------------
# zimfw aliases

# Branch (b)
gb() { git branch "$@"; }
gbc() { git checkout -b "$@"; }
gbd() { git checkout --detach "$@"; }
gbl() { git branch -vv "$@"; }
gbL() { git branch --all -vv "$@"; }
gbn() { git branch --no-contains "$@"; }
gbm() { git branch --move "$@"; }
gbM() { git branch --move --force "$@"; }
gbR() { git branch --force "$@"; }
gbs() { git show-branch "$@"; }
gbS() { git show-branch --all "$@"; }
gbu() { git branch --unset-upstream "$@"; }
gbG() { git-branch-remote-tracking gone | xargs -r git branch --delete --force "$@"; }
gbx() { git-branch-delete-interactive "$@"; }
gbX() { git-branch-delete-interactive --force "$@"; }

# Commit (c)
gc() { git commit --verbose "$@"; }
gca() { git commit --verbose --all "$@"; }
gcA() { git commit --verbose --patch "$@"; }
gcm() { git commit --message "$@"; }
gco() { git checkout "$@"; }
gcO() { git checkout --patch "$@"; }
gcf() { git commit --amend --reuse-message HEAD "$@"; }
gcF() { git commit --verbose --amend "$@"; }
gcp() { git cherry-pick "$@"; }
gcP() { git cherry-pick --no-commit "$@"; }
gcr() { git revert "$@"; }
gcR() { git reset "HEAD^" "$@"; }
gcs() { git show --pretty=format:"${_git_log_fuller_format}" "$@"; }
gcS() { git commit --verbose -S "$@"; }
gcu() { git commit --fixup "$@"; }
gcU() { git commit --squash "$@"; }
gcv() { git verify-commit "$@"; }

# Conflict (C)
gCl() { git --no-pager diff --diff-filter=U --name-only "$@"; }
gCa() { git add $(gCl) "$@"; }
gCe() { git mergetool $(gCl) "$@"; }
gCo() { git checkout --ours -- "$@"; }
gCO() { gCo $(gCl) "$@"; }
gCt() { git checkout --theirs -- "$@"; }
gCT() { gCt $(gCl) "$@"; }

# Data (d)
gd() { git ls-files "$@"; }
gdc() { git ls-files --cached "$@"; }
gdx() { git ls-files --deleted "$@"; }
gdm() { git ls-files --modified "$@"; }
gdu() { git ls-files --other --exclude-standard "$@"; }
gdk() { git ls-files --killed "$@"; }
gdi() { git status --porcelain --short --ignored | sed -n "s/^!! //p" "$@"; }
gdI() { git ls-files --ignored --exclude-per-directory=.gitignore --cached "$@"; }

# Fetch (f)
gf() { git fetch "$@"; }
gfa() { git fetch --all "$@"; }
gfp() { git fetch --all --prune "$@"; }
gfc() { git clone "$@"; }
gfm() { git pull --no-rebase "$@"; }
gfr() { git pull --rebase "$@"; }
gfu() { git pull --ff-only --all --prune "$@"; }

# Index (i)
gia() { git add "$@"; }
giA() { git add --patch "$@"; }
giu() { git add --update "$@"; }
giU() { git add --verbose --all "$@"; }
gid() { git diff --no-ext-diff --cached "$@"; }
giD() { git diff --no-ext-diff --cached --word-diff "$@"; }
gir() { git reset "$@"; }
giR() { git reset --patch "$@"; }
gix() { git rm --cached -r "$@"; }
giX() { git rm --cached -rf "$@"; }

# Log (l)
gl() { git log --date-order --pretty=format:"${_git_log_fuller_format}" "$@"; }
gls() { git log --date-order --stat --pretty=format:"${_git_log_fuller_format}" "$@"; }
gld() { git log --date-order --stat --patch --pretty=format:"${_git_log_fuller_format}" "$@"; }
glf() { git log --date-order --stat --patch --follow --pretty=format:"${_git_log_fuller_format}" "$@"; }
glo() { git log --date-order --pretty=format:"${_git_log_oneline_format}" "$@"; }
glO() { git log --date-order --pretty=format:"${_git_log_oneline_medium_format}" "$@"; }
glg() { git log --date-order --graph --pretty=format:"${_git_log_oneline_format}" "$@"; }
glG() { git log --date-order --graph --pretty=format:"${_git_log_oneline_medium_format}" "$@"; }
glv() { git log --date-order --show-signature --pretty=format:"${_git_log_fuller_format}" "$@"; }
glc() { git shortlog --summary --numbered "$@"; }
glr() { git reflog "$@"; }

# Merge (m)
gm() { git merge "$@"; }
gma() { git merge --abort "$@"; }
gmc() { git merge --continue "$@"; }
gmC() { git merge --no-commit "$@"; }
gmF() { git merge --no-ff "$@"; }
gms() { git merge --squash "$@"; }
gmS() { git merge -S "$@"; }
gmv() { git merge --verify-signatures "$@"; }
gmt() { git mergetool "$@"; }

# Push (p)
gp() { git push "$@"; }
gpf() { git push --force-with-lease "$@"; }
gpF() { git push --force "$@"; }
gpa() { git push --all "$@"; }
gpA() { git push --all && git push --tags --no-verify "$@"; }
gpt() { git push --tags "$@"; }
gpc() { git push --set-upstream origin "$(git-branch-current 2>/dev/null)" "$@"; }
gpp() { git pull origin "$(git-branch-current 2>/dev/null)" && git push origin "$(git-branch-current 2>/dev/null)" "$@"; }

# Rebase (r)
gr() { git rebase "$@"; }
gra() { git rebase --abort "$@"; }
grc() { git rebase --continue "$@"; }
gri() { git rebase --interactive --autosquash "$@"; }
grs() { git rebase --skip "$@"; }
grS() { git rebase --exec "git commit --amend --no-edit --no-verify -S" "$@"; }

# Remote (R)
gR() { git remote "$@"; }
gRl() { git remote --verbose "$@"; }
gRa() { git remote add "$@"; }
gRx() { git remote rm "$@"; }
gRm() { git remote rename "$@"; }
gRu() { git remote update "$@"; }
gRp() { git remote prune "$@"; }
gRs() { git remote show "$@"; }
gRS() { git remote set-url "$@"; }

# Stash (s)
gs() { git stash "$@"; }
gsa() { git stash apply "$@"; }
gsx() { git stash drop "$@"; }
gsX() { git-stash-clear-interactive "$@"; }
gsl() { git stash list "$@"; }
gsd() { git stash show --patch --stat "$@"; }
gsp() { git stash pop "$@"; }
gsr() { git-stash-recover "$@"; }
gss() { git stash save --include-untracked "$@"; }
gsS() { git stash save --patch --no-keep-index "$@"; }
gsw() { git stash save --include-untracked --keep-index "$@"; }
gsi() { git stash push --staged "$@"; } # requires Git 2.35
gsu() { git stash show --patch | git apply --reverse "$@"; }

# Submodule (S)
gS() { git submodule "$@"; }
gSa() { git submodule add "$@"; }
gSf() { git submodule foreach "$@"; }
gSi() { git submodule init "$@"; }
gSI() { git submodule update --init --recursive "$@"; }
gSl() { git submodule status "$@"; }
gSm() { git-submodule-move "$@"; }
gSs() { git submodule sync "$@"; }
gSu() { git submodule update --remote "$@"; }
gSx() { git-submodule-remove "$@"; }

# Tag (t)
gt() { git tag "$@"; }
gtl() { git tag --list --sort=-committerdate "$@"; }
gts() { git tag --sign "$@"; }
gtv() { git verify-tag "$@"; }
gtx() { git tag --delete "$@"; }

# Main working tree (w)
gws() { git status --short "$@"; }
gwS() { git status "$@"; }
gwd() { git diff --no-ext-diff "$@"; }
gwD() { git diff --no-ext-diff --word-diff "$@"; }
gwr() { git reset --soft "$@"; }
gwR() { git reset --hard "$@"; }
gwc() { git clean --dry-run "$@"; }
gwC() { git clean -d --force "$@"; }
gwm() { git mv "$@"; }
gwM() { git mv -f "$@"; }
gwx() { git rm -r "$@"; }
gwX() { git rm -rf "$@"; }

# ------------------------------------------------------------------------------
# my aliases
gll() { tig "$@"; }

gwdd() { DELTA_FEATURES=+side-by-side gwd "$@"; }
gwdt() { gwd --ext-diff "$@"; }
gwdn() { gwd --name-only "$@"; }
gwdh() { gwd HEAD "$@"; }
gwddh() { gwdd HEAD "$@"; }
gwdth() { gwdt HEAD "$@"; }
gwdnh() { gwdn HEAD "$@"; }
gcsd() { DELTA_FEATURES=+side-by-side gcs "$@"; }
gcst() { gcs --ext-diff "$@"; }
gcsn() { gcs --name-only --pretty="" "$@"; }
gcss() { git rev-parse HEAD "$@"; }
gcsj() { git show --no-patch "$@"; }
gcsc() { git show --stat "$@"; }

gcom() { gco master "$@"; }
gcomm() { gco origin/master "$@"; }
gcoh() { gco HEAD "$@"; }

gcu() { git add -A && git commit --amend --reuse-message HEAD "$@"; }

gc-wip() { git add -A && git commit -m 'wip' "$@"; }
gc-fix() { git add -A && git commit -m 'fix' "$@"; }
gc-upd() { git add -A && git commit -m 'update' "$@"; }
gc-kik() { git add -A && git commit -m 'kik' "$@"; }

gcp() { git cherry-pick "$@"; }
gcpa() { git cherry-pick --abort "$@"; }
gcpc() { git cherry-pick --continue "$@"; }

gbd() { gb -D "$@"; }
gbdr() {
  echo "$@" | xargs -n1 git branch -D
  echo "$@" | xargs -n1 -P0 git push origin --delete
}
