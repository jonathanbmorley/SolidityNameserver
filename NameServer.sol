pragma solidity ^0.4.0;

contract NameServer {
    
    address owner = msg.sender;
    
    mapping (string => address) hostnames;
    mapping (address => string) addresses;
    
    uint registrationCount = 0;
    
    modifier onlyBy(address _addr) {
        if (owner != _addr) throw;
        _;
    }
    
    modifier onlyByRegistrantOrOwner(address _sender, address _addr) {
        if (_addr == _sender || _sender == owner)
            _;
        else throw;
    }
    
    //Returns name associated with address
    function reverseResolve(address contractAddress) constant returns (string) {
        if (contractAddress == 0) throw;
        return addresses[contractAddress];
    }
    
    //Returns address associated with hostname
    function resolve(string hostname) constant returns (address) {
        address contractAddress = hostnames[hostname];
        return contractAddress;
    }
    
    function currentRegistryCount() constant returns (uint) {
        return registrationCount;
    }
    
    //Register a hostname to an address, only for your address or the contract owner
    function register(string hostname, address contractAddress) onlyByRegistrantOrOwner(msg.sender, contractAddress) {
        if (contractAddress == 0) throw;
        if (hostnames[hostname] != 0) throw;
        
        hostnames[hostname] = contractAddress;
        addresses[contractAddress] = hostname;
        registrationCount++;
    }
    
    //Update registration but only by address owner or contract owner
    function update(string hostname, address contractAddress) onlyByRegistrantOrOwner(msg.sender, contractAddress) {
        hostnames[hostname] = contractAddress;
        addresses[contractAddress] = hostname;
    }
    
    //Remove an entry but only by address owner or contract owner
    function remove(string hostname, address contractAddress) onlyByRegistrantOrOwner(msg.sender, contractAddress) {
        hostnames[hostname] = 0;
        addresses[contractAddress] = "";
        registrationCount--;
    }
    
    function suicide() onlyBy(owner) {
        selfdestruct(msg.sender);
    }
}
