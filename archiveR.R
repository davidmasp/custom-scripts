

# imports -----------------------------------------------------------------

library(magrittr)

# prams -------------------------------------------------------------------

folder_path = "../projects/mind-the-gap-analysis"
use_lastTime_repo = FALSE


if (interactive()){
  params_commit = TRUE
  params_pull = FALSE
  params_push = TRUE
} else {
  params_commit = FALSE
  params_pull =FALSE
  params_push = FALSE
}

# script ------------------------------------------------------------------


tryCatch({
  repo_info = gert::git_info(repo = folder_path)
  is_repo = TRUE
}, error = function(err){
  return(FALSE)
}) -> is_repo


if (is_repo) {
  lm_date_branch = max(gert::git_branch_list(local = TRUE, repo = folder_path)$updated)
}
lm_date_modified = max(fs::dir_info(path = folder_path)$modification_time)

# last mod date
if (use_lastTime_repo & is_repo) {
  lm_date_str = strftime(lm_date_branch, format = "%Y%m%d")
} else {
  lm_date_str = strftime(lm_date_modified, format = "%Y%m%d")
}



if (is_repo){



  ## find local branches
  ## git_branch_list(local = TRUE, repo = )

  ## find if status is empty
  status = gert::git_status(repo = folder_path)

  if (nrow(status) > 0){
    mssg = glue::glue("{nrow(status)} uncommited changes found, please commit them first")
    message(mssg)
    message(status$file)
    if (!interactive()){
      comm_d = readLines(prompt = "Commit changes?")
    } else {
      comm_d = ""
    }

    if ( (comm_d %in% c("yes","y")) | params_commit){
      gert::git_add(status$file, repo = folder_path)
      gert::git_commit(message = "pre-archive changes", repo = folder_path)
    } else {
      stop("stoped")
    }

  } else {
    message("no status files found!")
  }


  ## find if ahead behind
  tryCatch({
    ahead = gert::git_ahead_behind(repo = folder_path)
    has_remote = TRUE
  }, error = function(err){
    message("error in ahead, possible, local branch has no remote?")
    return(FALSE)
  }) -> has_remote

  if (has_remote){
    if (ahead$behind> 0){

      if (!interactive()){
        pull_d = readLines(
          prompt = glue::glue("{ahead$behind} behind, pull? [y/n]")
        )
      } else {
        pull_d = ""
      }

      if ( (pull_d %in% c("y","yes")) | params_pull ){
        gert::git_pull(repo = folder_path)
      } else {
        message("not pulling changes")
      }
    }

    if (ahead$ahead > 0){
      update_d <- readline(prompt=glue::glue("local repo {ahead$ahead} ahead, push? [y/n]"))
      if (update_d %in% c("y", "yes")){
        gert::git_push(repo = folder_path)
      } else {
        stop("STOPPED!")
      }
    }


    if (ahead$local == ahead$upstream){
      message("Repos match the last commit")
    }
  }
} else {
  message("No repo found, archiving.")
}


# output ------------------------------------------------------------------

file_path = fs::path_file(folder_path)
dir_path = fs::path_dir(folder_path)
file_path_out = glue::glue("{lm_date_str}_{file_path}.tar.gz")
file_out = fs::path(dir_path,file_path_out)
message(glue::glue("Archiving in {file_out}"))

cur_dir = getwd()
setwd(dir = dir_path)

utils::tar(files = file_path,
           tarfile = file_path_out,
           compression = "gzip")

setwd(cur_dir)

