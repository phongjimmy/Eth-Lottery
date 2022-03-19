//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;


contract LotteryData {

    struct LotteryInfo{
        uint256 lotteryId;
        uint256 ticketPrice;
        uint256 prizePool;
        address[] players;
        address winner;
        bool isFinished;
    }
    mapping(uint256 => LotteryInfo) public lotteries;

    uint256[] public allLotteries;

    uint public lotteryTicketPrice = 0.5 ether;

    address private manager;
    bool private isLotteryContractSet;
    address private lotteryContract;
    constructor(){
        manager = msg.sender;
    }

    modifier onlyManager(){
        require(msg.sender == manager, "not_action_allowed");
        _;
    }

    modifier onlyLoterryContract(){
        require(isLotteryContractSet, "not_action_allowed");
        require(msg.sender == lotteryContract, "only_lottery_manager_allowed");
        _;
    }

    function updateLotteryContract(address _lotteryContract) external onlyManager{
        isLotteryContractSet = true;
        lotteryContract = _lotteryContract;
    }

    function getAllLotteryIds() external view returns(uint256[] memory){
        return allLotteries;
    }


    function addLotteryData(uint256 _lotteryId) external onlyLoterryContract{
        LotteryInfo memory lottery = LotteryInfo({
            lotteryId: _lotteryId,
            ticketPrice: lotteryTicketPrice,
            prizePool: 0,
            players: new address[](0),
            winner: address(0),
            isFinished: false
        });
        lotteries[_lotteryId] = lottery;
        allLotteries.push(_lotteryId);
    }

    function addPlayerToLottery(uint256 _lotteryId, uint256 _updatedPricePool, address _player) external onlyLoterryContract{
        LotteryInfo storage lottery = lotteries[_lotteryId];
        require(lottery.lotteryId != 0, "lottery_not_found");
        lottery.players.push(_player);
        lottery.prizePool = _updatedPricePool;
    }


    function getLotteryPlayers(uint256 _lotteryId) public view returns(address[] memory) {
        LotteryInfo memory tmpLottery = lotteries[_lotteryId];
        require(tmpLottery.lotteryId != 0, "lottery_not_found");
        return tmpLottery.players;
    }

    function isLotteryFinished(uint256 _lotteryId) public view returns(bool){
        LotteryInfo memory tmpLottery = lotteries[_lotteryId];
        require(tmpLottery.lotteryId != 0, "lottery_not_found");
        return tmpLottery.isFinished;
    }

    function getLotteryPlayerLength(uint256 _lotteryId) public view returns(uint256){
        LotteryInfo memory tmpLottery = lotteries[_lotteryId];
        require(tmpLottery.lotteryId != 0, "lottery_not_found");
        return tmpLottery.players.length;
    }

    function getLottery(uint256 _lotteryId) external view returns(
        uint256,
        uint256,
        uint256 ,
        address[] memory,
        address ,
        bool
        ){
            LotteryInfo memory tmpLottery = lotteries[_lotteryId];
            require(tmpLottery.lotteryId != 0, "lottery_not_found");
            return (
                tmpLottery.lotteryId,
                tmpLottery.ticketPrice,
                tmpLottery.prizePool,
                tmpLottery.players,
                tmpLottery.winner,
                tmpLottery.isFinished
            );
    }

    function setWinnerForLottery(uint256 _lotteryId, uint256 _winnerIndex) external onlyLoterryContract {
        LotteryInfo storage lottery = lotteries[_lotteryId];
        require(lottery.lotteryId != 0, "lottery_not_found");
        lottery.isFinished = true;
        lottery.winner = lottery.players[_winnerIndex];
    }
}