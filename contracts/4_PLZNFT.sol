// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PLZNFT is ERC721URIStorage, Ownable(msg.sender) {
    uint256 private _tokenIdCounter = 1;

    constructor() ERC721("PLZNFT", "PLZNFT") {}

    // renounceOwnership 함수를 오버라이드하여 비활성화
    function renounceOwnership() view public override onlyOwner {
        // 아무런 작업도 수행하지 않거나 예외를 발생시키기
        revert("Renouncing ownership is disabled.");
    }


    // NFT를 민팅하고 바로 다른 주소로 전송하는 함수
    // 컨트랙트 소유자만 호출 가능 (onlyOwner)
    function mintAndTransfer(address recipient, string memory tokenURI) public onlyOwner {
        uint256 newTokenId = _tokenIdCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        _tokenIdCounter++;

        _safeTransfer(msg.sender, recipient, newTokenId, "");
    }
}
