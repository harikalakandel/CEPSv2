Authors: Andrea Faini and Paolo Castiglioni

email: faini.andrea@gmail.com; paolo.castiglioni@gmail.com

The code in FMFDFA.m and slpMFMSDFA.m is described in:

Castiglioni P., Faini A. (2019). "A Fast DFA algorithm for multifractal multiscale analysis of physiological time series"
Frontiers in Physiology
Specialty Section: Computational Physiology and Medicine

Please cite the above publication when referencing this material.

Copyright (C) 2019 Andrea Faini and Paolo Castiglioni

The FMFDFA.m and slpMFMSDFA.m are free software: you can redistribute them and/or modify
them under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


Example:

DFA1 and DFA2 calculation
[bs, Fq1, Fq2] = FMFDFA(signal, -5:1:5, 6, 4, 0)

Local slope for DFA1
[aq1, bse1, Fqe1] = slpMFMSDFA(bs, Fq1)

Local slope for DFA2
[aq2, bse2, Fqe2] = slpMFMSDFA(bs, Fq2)

