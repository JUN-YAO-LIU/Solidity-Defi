const { expect } = require("chai");
const { ethers } = require("hardhat");

const WETH_ADDRESS = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const DAI_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const DAI_DECIMALS = 18; 
const SwapRouterAddress = "0xE592427A0AEce92De3Edee1F18E0157C05861564"; 

const ercAbi = [
  // Read-Only Functions
  "function balanceOf(address owner) view returns (uint256)",
  // Authenticated Functions
  "function transfer(address to, uint amount) returns (bool)",
  "function deposit() public payable",
  "function approve(address spender, uint256 amount) returns (bool)",
];

describe("SimpleSwap", function () {
  it("Should provide a caller with more DAI than they started with after a swap", async function () {
    
    const factory = await ethers.getContractFactory("SimpleSwap");

    // interface test
    // const testInterface = await ethers.getContractFactory("ISwapRouter");
    // const _testInterface = await testInterface.deploy();

    // 因為合約創建要注入DI實例，那就直接把合約地址輸入。
    const factoryDeploy = await factory.deploy("0xE592427A0AEce92De3Edee1F18E0157C05861564");
    await factoryDeploy.deployed();

    const assert = await factoryDeploy.swapWETHForDAI(1); 
    expect(assert).is.equal(10)

  });
});