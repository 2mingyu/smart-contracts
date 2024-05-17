// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract PLZNFT is ERC721URIStorage, Ownable(msg.sender) {
    uint256 private _tokenIdCounter = 1;

    constructor() ERC721("PLZNFT", "PLZNFT") {}

    // approve를 오버라이드하여 비활성화
    function approve(address /*to*/, uint256 /*tokenId*/) public view override(ERC721, IERC721) onlyOwner {
        revert("Approve function is disabled.");
    }

    // setApprovalForAll을 오버라이드하여 비활성화
    function setApprovalForAll(address /*operator*/, bool /*approved*/) public view override(ERC721, IERC721) onlyOwner {
        revert("Set approval for all function is disabled.");
    }

    // transferFrom을 오버라이드하여 비활성화
    function transferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/) public view override(ERC721, IERC721) onlyOwner {
        revert("Transfer from function is disabled.");
    }

    // transferOwnership을 오버라이드하여 비활성화 또는 소유자만 가능하도록 수정
    function transferOwnership(address /*newOwner*/) public view override onlyOwner {
        revert("Transfer ownership function is disabled.");
    }

    // renounceOwnership 함수를 오버라이드하여 비활성화
    function renounceOwnership() view public override onlyOwner {
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
