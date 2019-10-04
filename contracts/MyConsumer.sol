pragma solidity 0.4.24;

import 'chainlink/contracts/ChainlinkClient.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract MyConsumer is ChainlinkClient, Ownable {
    uint256 private constant ORACLE_PAYMENT = 1 * LINK;

    uint256 public currentPrice;
    address internal oracle;
    string internal jobId;

    event PriceUpdated(
        bytes32 indexed requestId,
        uint256 timestamp,
        uint256 price
    );

    constructor(address _oracle, string _jobId) public Ownable() {
        setPublicChainlinkToken();
        oracle = _oracle;
        jobId = _jobId;
    }

    function requestPrice() public {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(jobId),
            this,
            this.fulfillEthereumPrice.selector
        );
        req.add(
            'get',
            'http://www.apilayer.net/api/live?access_key=a55e2ca91abdc7634d344c05a8f32781'
        );
        req.add('path', 'quotes.USDRUB');
        req.addInt('times', 100);
        sendChainlinkRequestTo(oracle, req, ORACLE_PAYMENT);
    }

    function fulfillEthereumPrice(bytes32 _requestId, uint256 _price)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit PriceUpdated(_requestId, now, _price);
        currentPrice = _price;
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            'Unable to transfer'
        );
    }

    function cancelRequest(
        bytes32 _requestId,
        uint256 _payment,
        bytes4 _callbackFunctionId,
        uint256 _expiration
    ) public onlyOwner {
        cancelChainlinkRequest(
            _requestId,
            _payment,
            _callbackFunctionId,
            _expiration
        );
    }

    function stringToBytes32(string memory source)
        private
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }

}
