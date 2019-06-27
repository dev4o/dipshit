OUTPUT="$(tail -2 text.out | cut -c 9- | tr 'gz' '\n')"
echo "${OUTPUT}" | mail -s "$(hostname -s) daily mysql import check" test@test.com

