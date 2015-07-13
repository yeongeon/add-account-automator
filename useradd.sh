#!/usr/bin/perl
use strict;
use Expect;


my $timeout=1;
my $num_args = $#ARGV + 1;

my $username=$ARGV[0];
my $password=$ARGV[1];
my $remote_host="";
my $is_remote=0;
 	 	
if ( $num_args >= 3 ) {
	$is_remote=$ARGV[2];
 	if ( $is_remote == 1 ) {
 		$remote_host=$ARGV[3];
 	}
}
my $command_remote="ssh root\@$remote_host \"useradd -m $username\"";
my $command_local="useradd -m $username";
my $exp;
if ( $is_remote == 1 ){
	$exp = Expect->spawn($command_remote) || die("Cannot spawn $command_remote: $!\n");
} else {
	$exp = Expect->spawn($command_local) || die("Cannot spawn $command_local: $!\n");
	
}
$exp->raw_pty(1);
LOGIN:
$exp->expect($timeout,
        '-re',
        qr'[#>:] $'
);
$exp->soft_close();

system("./passwd.sh", $username, $password, $is_remote, $remote_host);
