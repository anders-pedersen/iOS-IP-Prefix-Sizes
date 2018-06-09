  
**About this app**

This app is created to be used for practicing IP addressing, prefix lengths and routing entries. There are four quiz modes:  

*   Prefix Length: an IP address and a network prefix is given (e.g. 192.168.1.30 and 192.168.1.24) and the correct prefix length should be selected
*   Subnet mask: an IP address and a network prefix is given (e.g. 192.168.1.30 and 192.168.1.24) and the correct subnet mask should be selected
*   Network ID: an IP address and a prefix length is given (e.g. 192.168.1.1/24) and the correct network prefix should be selected
*   Route Entry: an IP address is given (e.g. 192.168.1.30) and the correct route entry should be selected

![](router.png)

  
**Subnetting and prefix sizes**

The prefix size can both be written as a number (e.g. /24) or as a subnet mask (e.g. 255.255.255.0). Both numbers express the same thing. Namely how many bits of a given 32-bit IPv4 address is assigned as network prefix.  
  
A subnet mask is a bitmask and you can get the network prefix by applying it with a bitwise AND operation to an IP address. A subnet mask can be translated to a prefix size by counting the number of bits that are set (i.e. equals “1”).  
Example: the subnet mask 255.0.0.0 have 8 bits out of 32 bits set and hence correspond to the prefix size /8.  
  
The remaining the bits of the IP address are assigned as host field. The larger the host field the more host can be assigned within the IP routing prefix.  
  

![](router.png)

  
**Longest match shortest path**

When a router forward an IP packet it needs to find a route entry in its routing table to find the next hop information.  
The default criteria for the best route is simple:  

*   The route entry need to match the destination IP address of the packet
*   Of all matching route entries the longest match is preferred (longest prefix length)
*   Of all longest matches the shortest path is preferred (smallest metric)

![](router.png)

  
**Calculator**

A calculator which converts between prefix lenght and subnet mask is included. Move the slider to adjust the value.
