// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Judicial {
    int256 casecount = 0;

    struct JudicialCase {
        int256 case_no;
        string title;
        string description;
        string[] defendents;
        string[] plantiffs;
        address filedby;
        //assigned by judge
        address defendentlawyer;
        address plantiflawyer;
        address hearingjudge;
        //after the judgement
        bool completed;
        string judgement;
        //can be filled by anyone
        string[] evidencename;
        string[] ipfsaddress;
        int256 evidencecount;
    }

    mapping(int256 => JudicialCase) private cases;
    address admin;

    constructor() {
        admin = msg.sender;
    }

    address[] polices;
    address[] lawyers;
    address[] judges;

    function isadmin() public view returns (bool) {
        return msg.sender == admin;
    }

    function isPolice() public view returns (bool) {
        bool found = false;
        for (uint256 index = 0; index < polices.length; index++) {
            if (polices[index] == msg.sender) {
                found = true;
                break;
            }
        }
        return found;
    }

    function isLawyer() public view returns (bool) {
        bool found = false;
        for (uint256 index = 0; index < lawyers.length; index++) {
            if (lawyers[index] == msg.sender) {
                found = true;
                break;
            }
        }
        return found;
    }

    function isJudge() public view returns (bool) {
        bool found = false;
        for (uint256 index = 0; index < judges.length; index++) {
            if (judges[index] == msg.sender) {
                found = true;
                break;
            }
        }
        return found;
    }

    modifier isAdmin() {
        require(msg.sender == admin, "This is a admin previledge");
        _;
    }

    modifier caseExists(int256 caseno) {
        require(caseno >= 0 && caseno < casecount, "Invalid case number");
        _;
    }

    modifier canCaseFile() {
        require(
            isPolice() || isLawyer() || isJudge(),
            "You are not permitted \n Only Police,Lawyer,Judge can file case/view case"
        );
        _;
    }

    function addJudge(address judgeaddress) public isAdmin {
        judges.push(judgeaddress);
    }

    function addLawyer(address lawyeraddress) public isAdmin {
        lawyers.push(lawyeraddress);
    }

    function addPolice(address policeaddress) public isAdmin {
        polices.push(policeaddress);
    }

    function createCase(
        string memory title,
        string memory description,
        string[] memory defendents,
        string[] memory plantiffs
    ) public canCaseFile {
        cases[casecount].title = title;
        cases[casecount].description = description;
        cases[casecount].defendents = defendents;
        cases[casecount].plantiffs = plantiffs;
        cases[casecount].filedby = msg.sender;
        cases[casecount].evidencecount = 0;
        cases[casecount].case_no = casecount;
        casecount++;
    }

    function registerDefendentLawyer(int256 caseno, address lawyeraddress)
        public
        caseExists(caseno)
    {
        require(isJudge(), "Only court can register a lawyer for case");
        cases[caseno].defendentlawyer = lawyeraddress;
    }

    function registerPlantifflawyer(int256 caseno, address lawyeraddress)
        public
        caseExists(caseno)
    {
        require(isJudge(), "Only court can register a lawyer for case");
        cases[caseno].plantiflawyer = lawyeraddress;
    }

    function uploadEvidence(
        int256 caseno,
        string memory name,
        string memory ipfsaddress
    ) public caseExists(caseno) {
        cases[caseno].evidencename.push(name);
        cases[caseno].ipfsaddress.push(ipfsaddress);
        cases[caseno].evidencecount++;
        // cases[caseno].evidencename[uint256(cases[caseno].evidencecount)] = name;
        // cases[caseno].ipfsaddress[
        //     uint256(cases[caseno].evidencecount)
        // ] = ipfsaddress;
    }

    function closeCase(int256 caseno, string memory judgement)
        public
        caseExists(caseno)
    {
        require(isJudge(), "Only judge can case the file");
        cases[caseno].completed = true;
        cases[caseno].judgement = judgement;
        cases[caseno].hearingjudge = msg.sender;
    }

    function getTotalCases() public view returns (int256) {
        return casecount;
    }

    // function getCasedetails(int256 caseno)
    //     public
    //     view
    //     canCaseFile
    //     returns (
    //         string memory title,
    //         string memory description,
    //         string[] memory defendents,
    //         string[] memory plantiffs,
    //         address filedby
    //     )
    // {
    //     return (
    //         cases[caseno].title,
    //         cases[caseno].description,
    //         cases[caseno].defendents,
    //         cases[caseno].plantiffs,
    //         cases[caseno].filedby
    //     );
    // }

    // function getCompleteCasedetails(int256 caseno)
    //     public
    //     view
    //     canCaseFile
    //     returns (
    //         address defendentlawyer,
    //         address plantiflawyer,
    //         string[] memory ev_name,
    //         address[] memory ipfsaddress,
    //         bool completed,
    //         string memory judgement
    //     )
    // {
    //     return (
    //         cases[caseno].defendentlawyer,
    //         cases[caseno].plantiflawyer,
    //         cases[caseno].evidencename,
    //         cases[caseno].ipfsaddress,
    //         cases[caseno].completed,
    //         cases[caseno].judgement
    //     );
    // }

    function getAllCases()
        public
        view
        canCaseFile
        returns (JudicialCase[] memory)
    {
        JudicialCase[] memory caseslist = new JudicialCase[](
            uint256(casecount)
        );

        for (int256 i = 0; i < casecount; i++) {
            caseslist[uint256(i)] = cases[i];
        }
        return caseslist;
    }
}
