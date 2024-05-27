// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BeverageOrdering is Ownable(msg.sender) {
    IERC20 public tokenContract;
    uint256 public pricePerBeverage = 1e18; // 가격은 1 PLZ로 설정

    struct Order {
        address customer;
        string beverage;
        bool fulfilled;
    }

    Order[] public orders;
    mapping(string => bool) public validBeverages;

    // renounceOwnership 함수를 오버라이드하여 비활성화
    function renounceOwnership() view public override onlyOwner {
        revert("Renouncing ownership is disabled.");
    }

    // 생성자에서 화폐 토큰 컨트랙트 주소를 입력받기
    constructor(address _tokenAddress) {
        tokenContract = IERC20(_tokenAddress);
        validBeverages["americano"] = true;
        validBeverages["caffelatte"] = true;
    }

    // 음료의 유효성 설정
    function setBeverageValidity(string memory beverage, bool isValid) public onlyOwner {
        validBeverages[beverage] = isValid;
    }

    // 주문 함수
    function orderBeverage(string memory beverage) public {
        require(tokenContract.balanceOf(msg.sender) >= pricePerBeverage, "Insufficient balance to place order");
        require(validBeverages[beverage], "Invalid beverage type");
        tokenContract.transferFrom(msg.sender, address(this), pricePerBeverage);

        orders.push(Order({
            customer: msg.sender,
            beverage: beverage,
            fulfilled: false
        }));
    }

    // 주문 완료 확인 함수
    function confirmOrder(uint256 orderIndex) public onlyOwner {
        require(orderIndex < orders.length, "Invalid order index");
        require(!orders[orderIndex].fulfilled, "Order already fulfilled");

        orders[orderIndex].fulfilled = true;
    }

    // 주문 정보 조회 함수
    function getOrder(uint256 orderIndex) public view returns (Order memory) {
        require(orderIndex < orders.length, "Invalid order index");
        return orders[orderIndex];
    }
}
