#!/bin/bash
grep -rL --include='*.java' "import ru.hh.deathstar" . > almost_harmless.txt
