module("luci.controller.sadog",package.seeall)
function index()
	entry({"admin","services","sadog"}).dependent=false
	entry({"admin","services","sadog","ping"},call("act_ping")).leaf=true
	entry({"admin","services","sadog","ping5"},call("ping5time")).leaf=true
	entry({"admin","services","sadog","ping10"},call("ping10time")).leaf=true
end
function act_ping()
	local result = { }
	result.index = luci.http.formvalue("index")
	result.ping = luci.sys.exec("ping -c 1 -W 1 %q 2>&1|grep -o 'time=[0-9]*.[0-9]'|awk -F '=' '{print$2}'" % luci.http.formvalue("domain"))
	luci.http.prepare_content("application/json")
	luci.http.write_json(result)
end
function ping5time()
	local result1 = { }
	result1.index = luci.http.formvalue("index")
	result1.ping = luci.sys.exec("ping -c 5 %q 2>&1|grep -o 'time=[0-9]*.[0-9]'|awk -F '=' '{print$2}'|awk '{sum+=$1} END {print sum/NR, (5-NR)/5*100}'" % luci.http.formvalue("domain"))
	luci.http.prepare_content("application/json")
	luci.http.write_json(result1)
end
function ping10time()
	local result1 = { }
	result1.index = luci.http.formvalue("index")
	result1.ping = luci.sys.exec("ping -c 10 %q 2>&1|grep -o 'time=[0-9]*.[0-9]'|awk -F '=' '{print$2}'|awk '{sum+=$1} END {print sum/NR, (10-NR)/10*100}'" % luci.http.formvalue("domain"))
	luci.http.prepare_content("application/json")
	luci.http.write_json(result1)
end