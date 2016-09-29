# Batch FTP Deploy

Simple batch scripts to deploy files to FTP with backup and maintenance mode support.

## Why

I wanted to create a small tool to automate FTP file transfers on my Windows machine and that's the result.

## Features

* Copy files to the server
* Put your site into maintenance mode
* Create backup of the remote files before upload

## Dependencies

It requires the [NcFTP](http://www.ncftp.com/) client installed locally. Download the Windows installer [here](http://www.ncftp.com/download/).

## Usage

You need to configure the varibles defined in the beginning of the file.

### Connection

* `user` - The FTP user
* `password` - The FTP password
* `server` - The FTP server name

### Directories

* `resource_dir` - The local directory the contains the local files you want to copy to the server.
* `maintenance_dir` - The local directory that contains the `index.html` and `.htaccess` files, that set your site into maintenance mode. _Example included_
* `backup_dir` - The local directory you want to copy the backup files to.
* `remote_dir` - Relative path to the FTP root that defines the remote directory where the files need to be uploaded.
* `site_dir_name` - The remote directory name on the server your site is in.

## Blog post and contact

I wrote a blog post about it in Hungarian, that you can check out here: [Automatizáld az FTP-re másolást](https://blog.serpens.hu/automatizald-az-ftpre-masolast)

You can contact me on Twitter if you want.

##Future

I plan to create a rollback script and several versions for various use cases.

If you got an idea, then drop in a PR. It is always welcome.