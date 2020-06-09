#include "generic_interface.h"

#include <iostream>
#include <fstream>
#include <algorithm>
#include <string>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <stdexcept>

using namespace std;

// TODO: Maybe I can delete this constructor, it should be enough to
// have a default constructor
GethInterface::GethInterface(int r, string ab, string ad, string cn, string cnb, string cl, string p) {

  robot = r;
  contractABI = readStringFromFile(ab);
  contractAddress = readStringFromFile(ad);
  containerName = cn;
  containerNameBase = cnb;
  containerExt = getContainerExtension(cn, "ethereum_eth");
  containerLocation = cl;
 
  ostringstream bs;
  string mybs = "ethereum_bootstrap.1";
  bs << mybs << "." << getContainerExtension(mybs, "ethereum_bootstrap");
  bootstrap = bs.str();

  ostringstream ss;
  ss << containerName << "." << containerExt;
  containerNameFull = ss.str();
  
  templatePath = p;
}

// Execute command line program and return string result
string GethInterface::exec(const string cmdStr) {
  const char* cmd = cmdStr.c_str();
  char buffer[128];
  std::string result = "";
  FILE* pipe = popen(cmd, "r");
  if (!pipe) throw std::runtime_error("popen() failed!");
  try {
    while (!feof(pipe)) {
      if (fgets(buffer, 128, pipe) != NULL)
	result += buffer;
    }
  } catch (...) {
    pclose(pipe);
    throw;
  }
  pclose(pipe);
  result = removeSpace(result);
  return result;
}

string GethInterface::removeSpace(string str) {

  string noSpace = str;
  
  noSpace.erase(std::remove(noSpace.begin(), 
			    noSpace.end(), '\n'),
		       noSpace.end());
  
  return noSpace;
}

void GethInterface::wrapSSH(std::string cmd) {
  ostringstream commandStream;
  commandStream << "ssh volker@164.15.10.90 -p39999 "
		<< cmd;
  exec(commandStream.str());
}

// Execute a docker command on a container
void GethInterface::dockerExec(const string cmd) {
  ostringstream commandStream;
  commandStream << "docker exec -d "
		<< containerNameFull << " "
		<< cmd;

  exec(commandStream.str());
  
  //wrapSSH(commandStream.str());
}


// Execute a docker command on a container
void GethInterface::dockerExecForeground(const string cmd) {
  ostringstream commandStream;
  commandStream << "docker exec -it "
    		<< containerNameFull << " "
		<< cmd;

  system(commandStream.str().c_str());
}

// Execute a docker command on a container
string GethInterface::dockerExecReturn(const string cmd) {

  ostringstream commandStream;
  commandStream << "docker exec -it "
    		<< containerNameFull << " "
		<< cmd;

  cout << commandStream.str() << endl;

  string result = exec(commandStream.str());
  return result;
}

string GethInterface::dockerExecBootstrapReturn(const string cmd) {
 
  ostringstream commandStream;
  commandStream << "docker exec -it "
    		<< bootstrap << " "
		<< cmd;

  string result = exec(commandStream.str());
  return result;
 
}

// Execute a docker command on a container using the system background
// command (&)
void GethInterface::dockerExecBackground(const string cmd) {
  ostringstream commandStream;
  commandStream << "docker exec -i "
  		<< containerNameFull << " "
 		<< cmd << " 2>&1 > /dev/null &";
  
  cout << commandStream.str() << endl;
 
  system(commandStream.str().c_str());
}


// Reads the first line from a file
string GethInterface::readStringFromFile(string fileName){
  string s;
  ifstream infile;
  infile.open(fileName.c_str());
  getline(infile, s); // Saves the line in s.
  infile.close();
  return s;
}

void GethInterface::execTemplate(std::string templateName) {
  ostringstream commandStream;
  commandStream << "bash /root/exec_cmd.sh \'loadScript(\""
		<< templatePath << templateName << ".txt"
		<< "\")\'";
  dockerExec(commandStream.str());
}


void GethInterface::execTemplate(std::string templateName, int numArgs,
				 int args[], long long wei) {
  ostringstream commandStream;
  commandStream << " bash /root/exec_cmd.sh \'loadScript(\""
		<< templatePath << templateName << ".txt"
		<< "\")\'";
  dockerExec(commandStream.str());
}

void GethInterface::scInterface(std::string function, long long wei) {
  ostringstream commandStream;
  commandStream << "bash /root/generic_sc_interface_0.sh \'"
		<< contractABI << "\' " << contractAddress << " "
		<< function << " " << wei;  
  dockerExecBackground(commandStream.str());
}


void GethInterface::scInterface(std::string function, int arg, long long wei) {
  ostringstream commandStream;
  commandStream << "bash /root/generic_sc_interface_1.sh \'"
		<< contractABI << "\' " << contractAddress << " "
		<< function << " " << arg << " " << wei;  
  dockerExecBackground(commandStream.str());
}

void GethInterface::scInterface(std::string function, int arg, std::string wei) {
  ostringstream commandStream;
  commandStream << "bash /root/generic_sc_interface_1.sh \'"
		<< contractABI << "\' " << contractAddress << " "
		<< function << " " << arg << " " << wei;  
  dockerExecBackground(commandStream.str());
}

void GethInterface::scInterfaceCall0(std::string function, long long wei) {
  ostringstream commandStream;
  commandStream << "bash /root/generic_sc_interface_call_0.sh \'"
		<< contractABI << "\' " << contractAddress << " "
		<< function << " " << wei;

  dockerExecForeground(commandStream.str());
}

// TODO: This function is not good because of the use of atoi; we
// should at least check if the result is an integer
string GethInterface::scReturn0(string function, long long wei) {

  ostringstream commandStream;
  commandStream << "bash /root/generic_sc_interface_call_0.sh \'"
		<< contractABI << "\' " << contractAddress << " "
		<< function << " " << wei;

  string s = dockerExecReturn(commandStream.str());
  cout << "s is " << s << endl;

  // For atoi, the input string has to start with a digit, so let's
  // search for the first digit
  size_t i = 0;
  for ( ; i < s.length(); i++ ) {
    if (isdigit(s[i])) break;
  }

  // remove the first chars, which aren't digits
  s = s.substr(i, s.length() - i );

  // convert the remaining text to an integer
  int id = atoi(s.c_str());
 
  std::ostringstream ss;
  ss << id;
  
  return ss.str();
}


void GethInterface::execGethCmd(std::string command) {
  ostringstream commandStream;
  cout << "containerName is " << containerName << endl;
  commandStream << "bash /root/exec_cmd.sh "
		<< "'" << command << "'";
  dockerExec(commandStream.str());
}


void GethInterface::execGethCmdBackground(string command) {
  ostringstream commandStream;
  commandStream << "bash /root/exec_cmd.sh "
		<< "'" << command << "'";
  dockerExecBackground(commandStream.str());
}


void GethInterface::unlockAccount() {
  // TODO: Use this command or use the template
  // TODO: Decide which one is better
  execGethCmd("personal.unlockAccount(eth.coinbase, \"\", 0)");
}	

void GethInterface::startMining() {
  execGethCmd("miner.start(1)");
}

void GethInterface::stopMining() {
  execGethCmd("miner.stop");
}

// TODO: This function could be implemented better, so that ARGoS is
// agnostic
void GethInterface::addPeer(string enode) {

  ostringstream commandStream;
  // TODO: A good idea might be to send the enode via an ARGoS message   
  commandStream << "admin.addPeer\(" << enode << ")";
  
  execGethCmdBackground(commandStream.str());
}
void GethInterface::removePeer(string enode) {

  ostringstream commandStream;
  // TODO: A good idea might be to send the enode via an ARGoS message   
  commandStream << "admin.removePeer\(" << enode<< ")";
  
  execGethCmdBackground(commandStream.str());
}

string GethInterface::getEnode() {
  string enode = dockerExecReturn("cat /root/my_enode.enode");
  return removeSpace(enode);
}	

string GethInterface::getBootstrap() {
  string enode = dockerExecBootstrapReturn("cat /root/my_enode.enode");
  return removeSpace(enode);
}

string GethInterface::getContractABI() {
  return contractABI;
}

void GethInterface::setContractABI(std::string abi) {
  contractABI = readStringFromFile(abi);
}

// Checks if a consensus was reached using the event interface
bool GethInterface::isConsensusReached() {

  ostringstream commandStream;
  // TODO: generic_event_interface_call_0 is not generic yet!
  commandStream << "bash /root/generic_event_interface_call_0.sh \'"
		<< contractABI << "\' " << contractAddress;

  string s = dockerExecReturn(commandStream.str());
  cout << "s is " << s << endl;

  // For atoi, the input string has to start with a digit, so let's
  // search for the first digit
  size_t i = 0;
  for ( ; i < s.length(); i++ ) {
    if (isdigit(s[i])) break;
  }

  // remove the first chars, which aren't digits
  s = s.substr(i, s.length() - i );

  // convert the remaining text to an integer
  int id = atoi(s.c_str());
 
  std::ostringstream ss;
  ss << id;

  cout << "Eventinterface is " << ss.str() << endl;
  
  if (ss.str() == "2") {
    return true;
  } else {
    return false;
  }  
}

std::string GethInterface::getContainerExtension(string cn, string containerName) {
  ostringstream commandStream;
  commandStream << "docker service ps -f \'name="
		<< cn << "\' "
		<< containerName // TODO: use a variable instead
		<< " -q --no-trunc | head -n1";

  cout << "Full command is " << commandStream.str() << endl;
  
  string id = exec(commandStream.str());

  cout << "containerExtension is " << id << endl;
  
  return id;
}

string GethInterface::getBlockChainSize() {
  string res = dockerExecReturn("du /root/.ethereum/devchain/geth/chaindata/");
  return res;
}
