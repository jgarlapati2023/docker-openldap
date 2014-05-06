#!/bin/sh

# Tests
error=0
ok=0

echo_start () {
  echo "------- Start $* test -------"
}

echo_error () {
  echo "\n$(tput setaf 1)/!\ $* failed$(tput sgr0)\n"
  error=`expr $error + 1`
}

echo_ok () {
  echo "\n--> $* ok\n"
  ok=`expr $ok + 1`
}

run_test () {
  fction=$1
  out=test/test.out

  echo_start $fction

  #./test/$1.sh | tee $out 2>&1
  ./test/$1.sh > $out 2>&1
  
  if [ "$(grep -c "$2" $out)" -eq 0 ]; then
    echo_error $fction
  else
    echo_ok  $fction
  fi

  rm $out
}


./test/tools/prepare.sh
run_test build "Successfully built"
run_test run-simple "dn: dc=example,dc=com"
run_test run-tls "dn: dc=example,dc=com"
./test/tools/end.sh

echo "------- Test finished -------"
echo $error " failed " $ok " passed"
