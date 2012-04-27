#!/usr/bin/perl -w


while (<STDIN>) {
	/^\s*(.+)\((.*)\)/;
	$fn = $1;
	local @args = split(',', $2);

	if ($fn eq "reserve") {
		@args == 3 || die "invalid args on reserve()";

		local $tag = join('.', @args[0..1]);
		$boats{$tag} = \@args;

	} elsif ($fn eq "oar_reserve") {
		@args == 4 || die "invalid args on oar_reserve()";

		local $tag = join('.', @args[0..1]);
		$oars{$tag} = \@args;

	} elsif ($fn eq "hotseat") {
		@args == 2 || die "invalid args on hotseat()";

		local $tag = join('.', @args);
		$hotseat{$tag} = 1;

	} elsif ($fn eq "hurry_back") {
		@args == 3 || die "invalid args on hurry_back()";

		local $tag = join('.', @args[0..1]);
		$hurry{$tag} = 1;
	}
}

# just to be safe, make sure there is are boat and oar assignments for each crew
foreach $tag (keys %boats) {
	if (!exists($oars{$tag})) {
		die "Missing oar assignment for race $race";
	}
}
foreach $tag (keys %oars) {
	if (!exists($boats{$tag})) {
		die "Missing boat assignment for race $race";
	}
}


$cell_separator = ',';

@columns = ("Event", "Crew", "Boat", "Oars", "Hotseating (out)", "Hurry Back (in)");
print join($cell_separator, @columns); print "\n";

foreach $tag (sort(keys(%boats))) {
	local $boat_info = $boats{$tag};
	local $oar_info = $oars{$tag};

	local $hotseat_tag = join('.', @{$boat_info}[0,2]);

	local @cells = @{$boat_info}[0..2];
	push(@cells, @{$oar_info}[2]);
	push(@cells, (exists $hotseat{$hotseat_tag} ? "Hotseat" : ""));
	push(@cells, (exists $hurry{$tag} ? "Hurry Back" : ""));

	print join($cell_separator, @cells); print "\n";
}
