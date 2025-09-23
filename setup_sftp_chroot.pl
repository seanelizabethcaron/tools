#!/usr/bin/perl

#
# Set up sshd_config directives for chroot accounts previously using scponlyc. Use of
#  scponlyc is deprecated in Ubuntu 22.04+ so this mechanism is now required
#
# The sshd_config file must contain the line:
#    Subsystem sftp internal-sftp
#

open(INFILE, '-|', 'cat /etc/passwd | grep scponlyc') or die $!;
open(OUTFILE, ">/etc/ssh/sshd_config.d/chroot_users.conf") or die "Failed opening output file!\n";

while (<INFILE>) {
    $line = $_;
    chomp $line;

    ($name,$pw,$uid,$gid,$gecos,$homedir,$shell) = split(":", $line);

    #
    # For each user account, spit out sshd_config entries of the following format:
    #
    # Match User user{n}
    #     ChrootDirectory /home/user{n}
    #     ForceCommand internal-sftp
    #     X11Forwarding no
    #     AllowTcpForwarding no
    #

    print OUTFILE "Match User " . $name . "\n";
    print OUTFILE "    ChrootDirectory " . $homedir . "\n";
    print OUTFILE "    ForceCommand internal-sftp\n";
    print OUTFILE "    X11Forwarding no\n";
    print OUTFILE "    AllowTcpForwarding no\n\n";
}

close(INFILE);
close(OUTFILE);

