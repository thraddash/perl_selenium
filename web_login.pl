#!/usr/bin/perl
use warnings;
use strict;
use WWW::Selenium;

open(INPUT,"../secret/my_cnf.cnf") or die "cant open secret file";
my %rightmgnt;

while(defined(my $line=<INPUT>)){
	if($line=~/^#/){
		next;
	}else{
		chomp($line);
		my($name,$password)=split(/:/,$line);
		$rightmgnt{$name}="$password";
	}
}

open(OUTPUT, ">:utf8", "output.html");

foreach my $name(keys %rightmgnt){
	my $sel = WWW::Selenium->new( host => "localhost",
                                  port => 4444,
                                  browser => "*chrome",
                                  browser_url => "http://righteverywhere.com",
                                );
	
	$sel->start;
	$sel->open("/Default.aspx");
	$sel->type("id=mLogin_UserName", "$name");
	$sel->type("id=mLogin_Password", "$rightmgnt{$name}");
	$sel->click("id=mLogin_lblbtnLogin");
	$sel->wait_for_page_to_load("30000");
	#$sel->capture_screenshot("a.png");
	$sel->click("id=ctl00_hdr_anav_LoginView1_HyperLink2");
	$sel->wait_for_page_to_load("30000");		
	#$sel->capture_entire_page_screenshot("b.png");
	my @stuff=$sel->get_body_text();
	foreach my $line(@stuff){
		print "$line\n";
	}
	#print OUTPUT $sel->get_body_text();
#	print OUTPUT $sel->get_html_source();
	$sel->stop;
}
close(OUTPUT);
