#!/usr/bin/env perl
package TAEB::Spoilers::Sokoban;
use MooseX::Singleton;

has level_maps => (
    is => 'ro',
    isa => 'HashRef',
    default => sub {
        my %sokolevels = (
"soko4-1" => {map_text => q(
------  ----- 
|....|  |...| 
|.Ah.----.C.| 
|.Bb.....Da.| 
|..|-|>|-|E.| 
---------|.---
|.g678<|.....|
|..----|F.c..|
--5|   |.G...|
 |4|---|dH...|
 |f.3210IeJ..|
 |..|---------
 ----         ),
    solution => [
	qw(Da ab Ec Hd I0),
	qw(J1),
	qw(Ge e2),
	qw(dI I3),
	qw(cJ Jf f4),
	qw(FI If f5),
	qw(CJ Jf fg g6),
	qw(Ah BA ba aJ Jf fg g7),
	qw(hb ba aJ Jf fg g8)]},
"soko4-2" => {map_text => q(
-------- ------
|<|>...|-|....|
|9|-.ABm.nbG..|
|8||.aCD|kFgH.|
|7||....|ihlj.|
|6|-----|E-----
|5|    |......|
|4-----|dce...|
|f.3210IJKL...|
|..|---|......|
----   --------),
    solution => [
	qw(Aa Bb Ec Jd I0),
	qw(Le K1),
	qw(dJ J2),
	qw(eL L3),
	qw(cK Kf f4),
	qw(Gg bG Fh hi iK Kf f5),
	qw(Hj ji iK Kf f6),
	qw(gk kK Kf f7),
	qw(Gl li iK Kf f8),
	qw(Dm mb bh hi iK Kf f9)]},
"soko3-1" => {map_text => q(
-----------       -----------
|....|....|--     |.........|
|.bAB|CE...>|     |.........|
|.jk..D.l.|--     |.........|
|....|....|       |....<....|
|-.---------      |.........|
|.iF.|.....|      |.........|
|.GH.|M.OeS|      |.........|
|.gIh...cQ.|      |.........|
|.JKL|N..Rd|---------------+|
|....|..PfT.0123456789!"#$%.|
-----------------------------),
    solution => [
	qw(Dk kl Gb Ic Rd T0),
	qw(P1),
	qw(Qe dT T2),
	qw(ST T3),
	qw(ef f4),
	qw(OS ST T5),
	qw(cP P6),
	qw(Jg gc cP P7),
	qw(KI Ic cP P8),
	qw(Lh hc cP P9),
	qw(HG Gg gc cP P!),
	qw(bg gc cP P"),
	qw(Fi ij jg gc cP P#),
	qw(Ak kj jg gc cP P$),
	qw(lj jg gc cP P%)]},
"soko3-2" => {map_text => q(
 ----          -----------
-|.>|-------   |.........|
|.m........|   |.........|
|.A-----B-.|   |.........|
|.n|...|hC.|   |....<....|
|.D.Eoi.gF-|   |.........|
|.Gl.H.p|..|   |.........|
|.----Ic--.|   |.........|
|..J..aK.|.--  |.........|
|.---L-j.eM.------------+|
|...|..N-.O.0123456789!".|
|.dP.b.f.k----------------
----|..|..|
    -------               ),
    solution => [
	qw(Bg Ch Ja Lb O0),
	qw(Kc aJ bL Pd Nf Me FC gi cj eM MO O1),
	qw(Lb fk ke eM MO O2),
	qw(jf fk ke eM MO O3),
	qw(Ia aK Kf fk ke eM MO O4),
	qw(bL dk ke eM MO O5),
	qw(JK Kf fk ke eM MO O6),
	qw(Lb bk ke eM MO O7),
	qw(Gl hg Ch Am Dn Eo ia aK Kf fk ke gi eM MO O8),
	qw(ia aK Kf fk ke eM MO O9),
	qw(oi ia aK Kf fk ke eM MO O!),
	qw(Hp pf fk ke eM MO O")]},
"soko2-1" => {map_text => q(
--------------------
|........|...|.....|
|.ABfc-EF|.-.|.....|
|..|eC.D.|GH.|.....|
|-.|..-.d|.-.|..<..|
|...--.......|.....|
|...|.M.-...-|.....|
|.Ib|L.|...--|.....|
|-J.|..|----------+|
|.aK.gh.0123456789.|
|...|.>|------------
--------            ),
    solution => [
	qw(Ka a0),
	qw(Ib Ja a1),
	qw(bK K2),
	qw(Aa a3),
	qw(BA Aa a4),
	qw(Cc Fd De ef cC fA Aa a5),
	qw(Ce ef fA Aa a6),
	qw(ED De ef fA Aa a7),
	qw(Mh h8),
	qw(Lg g9)]},
"soko2-2" => {map_text => q(
  --------          
--|.|....|          
|...Ajf..|----------
|.-iBC-DE|.|.......|
|.FG-......|.......|
|.-h.H.|g..|.......|
|....-I--J-|...<...|
|..KL..M...|.......|
|.--...|...|.......|
|..ce-N|---|.......|
--|abO.|----------+|
  |.dP>0123456789!.|
  ------------------),
    solution => [
	qw(Oa P0),
        qw(N> >1),
	qw(Lb ac bd d2),
	qw(ce ed d3),
	qw(KL Ld d4),
	qw(GK KL Ld d5),
	qw(FG GK KL Ld d6),
	qw(Af Eg Hh hK KL Ld d7),
	qw(CH Hh hK KL Ld d8),
	qw(Bi iK KL Ld d9),
	qw(fj jH Hh hK KL Ld d!)]},
"soko1-1" => {map_text => q(
--------------------------
|>.....q0123456789!"#$%&.|
|.......|---------------.|
-------.------         |.|
 |.....po....|         |.|
 |.A.B.ClD.E.|         |.|
--------.-----         |.|
|.i.FsHknI.J.|         |.|
|...Gj..m....|         |.|
-----.--------   ------|.|
 |..LrNuP...|  --|.....|.|
 |...v.O.ba.|  |.+.....|.|
 |.K.M.c.Q.|-  |-|.....|.|
-------.----   |.+.....+.|
|.gRh.ft.|     |-|.....|--
|.e....d.|     |.+.....|  
|...|-----     --|.....|  
-----            -------  ),
    solution => [
	qw(Oa ab Qc cd de Rf eg gh Mc cd de eg Fi Gj jM MQ HF Ik Cl lm mj jM Mc
           Dl lm mj kn no op pq q0),
	qw(jM Fn no op pq q1),
	qw(in no op pq q2),
	qw(Jn no op pq q3),
	qw(Lr rs sn no op pq q4),
	qw(Nr rs sn no op pq q5),
	qw(ba Pr rs sn no op pq q6),
	qw(cd de ft tu ur rs sn no op pq q7),
	qw(ht tu ur rs sn no op pq q8),
	qw(gt tu ur rs sn no op pq q9),
	qw(eg gt tu ur rs sn no op pq q!),
	qw(aO Ou ur rs sn no op pq q"),
	qw(Mc cd de eg gt tu ur rs sn no op pq q#),
	qw(Qc cd de eg gt tu ur rs sn no op pq q$),
	qw(Kc cd de eg gt tu ur rs sn no op pq q%),
	qw(Bl lm mj jv vs sn no op pq q&)]},
"soko1-2" => {map_text => q(
  ------------------------
  |.j0123456789!"#$%&'~..|
  |..-------------------.|
----.|    -----        |.|
|..|A--  --...|        |.|
|.i.k.|--|.Nr.|        |.|
|.BCh.|..|.eO.|        |.|
--..DE|f..PQd--        |.|
 |FgmG.n.|R..|   ------|.|
 |.HI.|..|scS| --|.....|.|
 |.JlK|--|bT.| |.+.....|.|
 |...q.p.|..-- |-|.....|.|
 ----.Lo.|.--  |.+.....+.|
    ---.--.|   |-|.....|--
     |.M..a|   |.+.....|  
     |>.|..|   --|.....|  
     -------     -------  ),
    solution => [
	qw(Ma ab Tc Sd Qe Pf Gg Dh Bi iB Aj j0),
	qw(EG hj j1),
	qw(Bi ik kj j2),
	qw(Ch hj j3),
	qw(Il GE lj j4),
	qw(Jl lj j5),
	qw(HI Ij j6),
	qw(Fi ik kj j7),
	qw(gm mj j8),
	qw(EG Gm mj j9),
	qw(KG Gm mj j!),
	qw(fn nm mj j"),
	qw(Lo op pq qG Gm mj j#),
	qw(cT RP Pf fn nm mj j$),
	qw(bP Pf fn nm mj j%),
	qw(Tb bP Pf fn nm mj j&),
	qw(Nr ec cs sP Pf fn nm mj j'),
	qw(rN Nc cs sP Pf fn nm mj j~)]},
            );
	# Unpack the map from the human-readable representation above
	# into a true in-memory representation.
	for my $levelname (keys %sokolevels) {
	    my $level = $sokolevels{$levelname};
	    my $map_text = $level->{'map_text'};
	    my %map = ();
	    my %locations = ();
	    my $x = 0;
	    my $y = -1; # there's an initial newline
	    while ($map_text ne '') {
		my $char = substr $map_text,0,1,"";
		if ($char eq "\n") {
		    $y++;
		    $x = 0;
		    next;
		}
		$map{$x,$y} = $char;
		$locations($char) = [$x,$y];
		$x++;
	    }
	    $level->{'map'} = \%map;
	    $level->{'locations'} = \%locations;
	}
        return \%sokolevels;
    },
);

=head2 next_sokoban_step Level [Pathable] -> Maybe Tile

Return the tile that we need to head to next to solve the Sokoban
puzzle on Level. If the tile is a boulder, we're standing in the right
place and should push the boulder; if it's a floor tile, we should go
there; and if it's undef, either we're finished or we've deviated from
the spoilers. The optional second argument is a coderef which takes a
tile as argument and returns whether it's possible to path to that tile
by walking; if not given, it uses the built-in TAEB pathing routines.
(This is needed because the solution from a given configuration can
depend on which side of the boulders TAEB is standing; out of the
several possible moves, only one will be routable, and it returns that
move.)

This routine errors out if the level given is not a Sokoban level (in
that it doesn't match any of the maps it has spoilers for); it exits
silently with undef if the level is already solved, and gives a
warning and exits with undef if the level cannot be solved from here
based on its current knowledge. Note that this routine merely
specifies what the next move is; it does not guarantee that the move
is possible (for instance, there might be a monster behind the
boulder).

This routine does not make any assumptions about the behavior of the
AI, and is stateless (it is based entirely on current information,
rather than anything memorised).

=cut
sub next_sokoban_step {
    my $self = shift;
    my $level = shift;
    my $pathable = shift;
    my $left = 99;
    my $top = 99;
    # TAEB is where it is if it's on the level; otherwise, it'll
    # arrive at the nearest exit.
    my $tilefrom = TAEB->current_tile;
    if ($tilefrom->level != $level) {
        $tilefrom = $level->exit_towards(TAEB->current_level);
        return undef unless $tilefrom; # can't path to Sokoban
    }

    # Find out where the Sokoban map is on the screen.
    $level->each_tile(
        sub {
            my $t = shift;
            if ($t->type eq 'wall') {
                $t->x < $left and $left = $t->x;
                $t->y < $top  and $top  = $t->y;
            }
        });
    my $variant = undef;
    # Find out which variant this is, by comparing wall locations.
    FINDVARIANT: for my $variantcheck (keys %{$self->level_maps}) {
        my $map = $self->level_maps->{$variantcheck};
        my @mapchars = split //, $map;
        my $x = $left;
        my $y = $top;
        shift @mapchars; # get rid of the newline at the start
        while ($mapchars[0] ne "\n" || $mapchars[1] ne "\n") {
            my $tile = $level->at($x,$y);
            $tile->type eq 'wall' and $mapchars[0] !~ /[-|]/
                                  and next FINDVARIANT;
            $tile->type ne 'wall' and $mapchars[0] =~ /[-|]/
                                  and next FINDVARIANT;
            (shift @mapchars) eq "\n" ? (($x = $left),$y++) : $x++;
        }
        $variant = $variantcheck;
        last;
    }
    $variant or TAEB->log->spoiler("Could not determine Sokoban variant",
                                   level => 'error') and return;
    my @map = split /\n\n/, $self->level_maps->{$variant};
    my $letteredmap = $map[0];
    my @maplines = split /\n/, $letteredmap;
    shift @maplines;
    my $solution = $map[1];
    # Find out how many pits have been filled already.
    my $remainingpits = 0;
    $level->each_tile(sub {
        my $t=shift;
        $remainingpits++ if $t->type eq 'trap';
    });
    $remainingpits or return; # already solved
    my @steps = split /\n/, $solution;
    # Work out where the boulders will be after the pits that we've
    # seen missing have been eliminated.
    my @sofar = splice @steps, 0, -$remainingpits;
    my $boulderlocations = $letteredmap;
    $boulderlocations =~ s/[^A-Z]//g;
    s/([^ ])([^ ])/do {
        my ($a,$b)=($1,$2);
        $boulderlocations =~ s.\Q$a\E.$b.g;
        ""}/ge for @sofar;
    my @boulderlocations = split //, $boulderlocations;
    $boulderlocations = join "", sort @boulderlocations;
    $boulderlocations =~ s/[0-9!"#\$\%\&'~]//g;
    # Find out where the boulders actually are.
    my $currentboulderlocations = '';
    my $misplaced_x = undef;
    my $misplaced_y = undef;
    $level->each_tile(sub {
        my $t=shift;
        if ($t->has_boulder) {
            my $y = $t->y - $top;
            my $x = $t->x - $left;
            my $line = $maplines[$y];
            my $char = substr $line, $x, 1;
            $currentboulderlocations .= $char;
            $char eq '.' and $misplaced_x = $x;
            $char eq '.' and $misplaced_y = $y;
        }
    });
    my @currentboulderlocations = split //, $currentboulderlocations;
    $currentboulderlocations = join "", sort @currentboulderlocations;
    if($currentboulderlocations =~ /\.\./) {
        TAEB->log->spoiler("This Sokoban puzzle has deviated from spoilers.",
                           level => 'warning');
        return;
    }

    # Find out how far we are with this strategy already.
    # Sometimes there will be more than one possibility; we find out
    # which by attempting to path from TAEB's current location to the
    # location it should be aiming to next (which will be impossible
    # if this is the wrong possibility).
    my $plan = $steps[0];
    my ($working_x, $working_y);
    while($plan =~ /[^ ]/) {
        $plan =~ /([^ ])([^ ])/;
        my $nextmovef = $1;
        my $nextmovet = $2;
        my ($xf, $yf) =
            $self->_location_from_map_and_letter($letteredmap,$nextmovef);
        $nextmovef eq '.' and ($xf, $yf) = ($working_x, $working_y);
        my ($xt, $yt) =
            $self->_location_from_map_and_letter($letteredmap,$nextmovet);
        if($currentboulderlocations eq $boulderlocations &&
           (!defined($misplaced_x) ||
            ($misplaced_x == $working_x && $misplaced_y == $working_y))) {
            # This is a potential match for the plan.
            my ($x, $y);
            if ($xf == $xt) {
                # Moving up or down
                $x = $xf;
                $y = ($yf > $yt ? $yf+1 : $yf-1);
            } elsif ($yf == $yt) {
                # Moving left or right
                $y = $yf;
                $x = ($xf > $xt ? $xf+1 : $xf-1);
            } else {
                TAEB->log->spoiler("Sokoban spoilers move a boulder diagonally",
                                   level => 'error');
                return;
            }
            if($tilefrom->x - $left == $x && $tilefrom->y - $top  == $y) {
                # We're in the right location, push the boulder.
                return ($level->at($xf + $left, $yf + $top), $plan);
            }
            my $temptile = $level->at($x + $left, $y + $top);
            if ($pathable) {
                if (&$pathable($temptile)) {
                    return $temptile;
                }
            } else {
                my $path = TAEB::World::Path->calculate_path
                    ($tilefrom, $temptile, through_unknown => 1);
                if($path->path ne '') {
                    # We can path to the right location, so do so.
                    return $temptile;
                }
            }
        }
        # Move one step through the plan.
        $xf != $xt and $xf += ($xt <=> $xf);
        $yf != $yt and $yf += ($yt <=> $yf);
        my $letterto =
            $self->_letter_from_map_and_location($letteredmap, $xf, $yf);
        ($working_x, $working_y) = ($xf, $yf);
        $plan =~ s/^(.)/$letterto/;
        my $letterfrom = $1;
        $plan =~ s/^(.)\1 ?//;
        $boulderlocations =~ s/\Q$letterfrom\E/$letterto/;
        @boulderlocations = split //, $boulderlocations;
        $boulderlocations = join "", sort @boulderlocations;
    }
    TAEB->log->spoiler("This Sokoban puzzle has deviated from spoilers.",
                       level => 'warning');
    return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
