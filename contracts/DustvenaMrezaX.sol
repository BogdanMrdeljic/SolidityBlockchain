// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract DrustvenaMrezaXY
{

    uint public NAJDUZA_MOGUCA_DUZINA_PORUKE = 280;
    struct Porukica{
        uint id;
        address autor;
        string sadrzajPoruke;
        uint vreme_slanja;
        uint BrPregleda;
    }

    mapping(address => Porukica[]) public porukice;
    address public vlasnik;

    event KreiranaPorukica(uint id, address autor,
     string sadrzajPoruke, uint vreme_slanja,uint BrPregleda);

     event PregledanaPorukica(address viewer,address autor, uint porukaId, uint BrPregleda);

     constructor()
     {
        vlasnik = msg.sender;
     }

     modifier JedniniVlasnik()
     {
        require(msg.sender == vlasnik, "Niste vlasnik ugovora!");
        _;
     }

     function AzurirajPorukicu(uint duzinaPoruke) public JedniniVlasnik
     {
        NAJDUZA_MOGUCA_DUZINA_PORUKE = duzinaPoruke;
     }

    function NapisiPorukicu(string memory _sadrzaj) public
    {
        require(bytes(_sadrzaj).length <= NAJDUZA_MOGUCA_DUZINA_PORUKE, "Poruka je predugacka!");
        Porukica memory novaPorukica = Porukica({
            id:porukice[msg.sender].length,
            autor:msg.sender,
            sadrzajPoruke:_sadrzaj,
            vreme_slanja:block.timestamp,
            BrPregleda : 0
        });
    porukice[msg.sender].push(novaPorukica);

    emit KreiranaPorukica(novaPorukica.id, novaPorukica.autor, novaPorukica.sadrzajPoruke,
    novaPorukica.vreme_slanja, novaPorukica.BrPregleda);
    }

    function PregledajPorukicu(address autor, uint id) external 
    {
        require(porukice[autor][id].id == id, "Porukica ne postoji!");

        porukice[autor][id].BrPregleda++;

        emit PregledanaPorukica(msg.sender, autor, id, porukice[autor][id].BrPregleda);
    }

    function getPorukica(uint ident) public view returns (Porukica memory)
    {
        return porukice[msg.sender][ident];
    }

    function getSveMojePorukice(address ouner) public view returns (Porukica[] memory)
    {
        return porukice[ouner];
    }

}