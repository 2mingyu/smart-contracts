// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PLZToken is ERC20, Ownable(msg.sender) {
    IERC721 public nftContract;
    mapping(address => uint256) public lastRequestedAt;

    // 생성자에서 NFT 컨트랙트 주소를 입력 받습니다.
    constructor(address _nftAddress) ERC20("PLZToken", "PLZ") {
        nftContract = IERC721(_nftAddress);
        _mint(msg.sender, 1e24);  // 초기 공급량 설정 (예: 1,000,000 PLZ)
    }

    // renounceOwnership 함수를 오버라이드하여 비활성화
    function renounceOwnership() view public override onlyOwner {
        revert("Renouncing ownership is disabled.");
    }

    // NFT 소유자만이 토큰을 요청할 수 있고, 하루에 한 번만 요청 가능
    function requestTokens() public {
        require(nftContract.balanceOf(msg.sender) > 0, "You must own at least one NFT");
        require(block.timestamp >= lastRequestedAt[msg.sender] + 1 days, "You can only request tokens once every 24 hours");

        _mint(msg.sender, 2 * 1e18);  // 2 PLZ를 발행
        lastRequestedAt[msg.sender] = block.timestamp;  // 마지막 요청 시간 업데이트
    }
}
