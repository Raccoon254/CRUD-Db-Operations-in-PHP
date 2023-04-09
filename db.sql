
CREATE TABLE `contract` (
`vId` int(11) NOT NULL,
`ctId` int(11) NOT NULL,
`Sdate` date DEFAULT NULL,
`Ctime` time DEFAULT NULL,
`Cname` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `customer` (
`cId` int(11) NOT NULL,
`Cname` varchar(45) DEFAULT NULL,
`Street` text DEFAULT NULL,
`City` varchar(45) DEFAULT NULL,
`StateAb` varchar(4) DEFAULT NULL,
`Zipcode` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `employee` (

`sId` int(11) DEFAULT NULL,
`SSN` bigint(20) NOT NULL,
`Ename` varchar(45) DEFAULT NULL,
`Street` varchar(45) DEFAULT NULL,
`City` varchar(20) DEFAULT NULL,
`StateAb` varchar(4) DEFAULT NULL,
`Zipcode` varchar(12) DEFAULT NULL,
`Etype` varchar(2) DEFAULT NULL,
`Bdate` date DEFAULT NULL,
`Sdate` date DEFAULT NULL,
`Edate` date DEFAULT NULL,
`Level` varchar(45) DEFAULT NULL,
`Asalary` int(11) DEFAULT NULL,
`Agency` varchar(45) DEFAULT NULL,
`Hsalary` int(11) DEFAULT NULL,
`Institute` varchar(45) DEFAULT NULL,
`Itype` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `item` (
`iId` int(11) NOT NULL,
`Iname` varchar(45) DEFAULT NULL,
`Sprice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `oldprice` (
`iId` int(11) NOT NULL,
`Sprice` int(11) DEFAULT NULL,
`Sdate` date NOT NULL,
`Edate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `order` (
`oId` int(11) NOT NULL,
`sId` int(11) NOT NULL,
`Odate` date DEFAULT NULL,
`Ddate` date DEFAULT NULL,
`Amount` int(11) DEFAULT NULL,
`cId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `order_item` (
`oId` int(11) NOT NULL,
`sId` int(11) NOT NULL,

`iId` int(11) NOT NULL,
`Icount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `store` (
`sId` int(11) NOT NULL,
`Sname` varchar(40) DEFAULT NULL,
`Street` varchar(40) DEFAULT NULL,
`City` varchar(40) DEFAULT NULL,
`StateAb` varchar(4) DEFAULT NULL,
`ZipCode` varchar(30) DEFAULT NULL,
`Sdate` date DEFAULT NULL,
`Telno` bigint(20) DEFAULT NULL,
`URL` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `store_customer` (
`sId` int(11) NOT NULL,
`cId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `store_item` (
`sId` int(11) NOT NULL,

`iId` int(11) NOT NULL,
`Scount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `vendor` (
`vId` int(11) NOT NULL,
`Vname` varchar(45) DEFAULT NULL,
`Street` varchar(45) DEFAULT NULL,
`City` varchar(30) DEFAULT NULL,
`StateAb` varchar(4) DEFAULT NULL,
`Zipcode` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `vendor_item` (
`vId` int(11) NOT NULL,
`iId` int(11) NOT NULL,
`Vprice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `vendor_store` (
`vId` int(11) NOT NULL,
`sId` int(11) NOT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `contract`
ADD PRIMARY KEY (`vId`,`ctId`);

ALTER TABLE `customer`
ADD PRIMARY KEY (`cId`);

ALTER TABLE `employee`
ADD PRIMARY KEY (`SSN`),
ADD KEY `store_employee` (`sId`);

ALTER TABLE `item`
ADD PRIMARY KEY (`iId`);

ALTER TABLE `oldprice`
ADD PRIMARY KEY (`iId`,`Sdate`);

ALTER TABLE `order`
ADD PRIMARY KEY (`oId`,`sId`),

ADD KEY `store_order` (`sId`);

ALTER TABLE `order_item`
ADD PRIMARY KEY (`oId`,`sId`,`iId`),
ADD KEY `store_fk` (`sId`),
ADD KEY `item_fk` (`iId`);

ALTER TABLE `store`
ADD PRIMARY KEY (`sId`);

ALTER TABLE `store_customer`
ADD PRIMARY KEY (`sId`,`cId`),
ADD KEY `customer_sc` (`cId`);

ALTER TABLE `store_item`
ADD PRIMARY KEY (`sId`,`iId`),
ADD KEY `item_fk1` (`iId`);

ALTER TABLE `vendor`
ADD PRIMARY KEY (`vId`);

ALTER TABLE `vendor_item`
ADD PRIMARY KEY (`vId`,`iId`),
ADD KEY `vendor_iId` (`iId`);

ALTER TABLE `vendor_store`
ADD PRIMARY KEY (`vId`,`sId`),
ADD KEY `sid_fk` (`sId`);

ALTER TABLE `contract`
ADD CONSTRAINT `vendor_contract_fk` FOREIGN KEY (`vId`) REFERENCES `vendor` (`vId`) ON
DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `employee`
ADD CONSTRAINT `store_employee` FOREIGN KEY (`sId`) REFERENCES `store` (`sId`) ON DELETE NO
ACTION ON UPDATE NO ACTION;

ALTER TABLE `oldprice`
ADD CONSTRAINT `iId_old_fk` FOREIGN KEY (`iId`) REFERENCES `item` (`iId`) ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE `order`
ADD CONSTRAINT `store_order` FOREIGN KEY (`sId`) REFERENCES `store` (`sId`) ON DELETE NO
ACTION ON UPDATE NO ACTION;

ALTER TABLE `order_item`
ADD CONSTRAINT `item_fk` FOREIGN KEY (`iId`) REFERENCES `item` (`iId`) ON DELETE NO ACTION
ON UPDATE NO ACTION,
ADD CONSTRAINT `order_fk` FOREIGN KEY (`oId`) REFERENCES `order` (`oId`) ON DELETE NO
ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `store_fk` FOREIGN KEY (`sId`) REFERENCES `store` (`sId`) ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE `store_customer`
ADD CONSTRAINT `customer_sc` FOREIGN KEY (`cId`) REFERENCES `customer` (`cId`) ON DELETE NO
ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `store_sc` FOREIGN KEY (`sId`) REFERENCES `store` (`sId`) ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE `store_item`
ADD CONSTRAINT `item_fk1` FOREIGN KEY (`iId`) REFERENCES `item` (`iId`) ON DELETE NO ACTION
ON UPDATE NO ACTION,
ADD CONSTRAINT `store_fk1` FOREIGN KEY (`sId`) REFERENCES `store` (`sId`) ON DELETE NO
ACTION ON UPDATE NO ACTION;

ALTER TABLE `vendor_item`
ADD CONSTRAINT `vendor_iId` FOREIGN KEY (`iId`) REFERENCES `item` (`iId`) ON DELETE NO
ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `vendor_vid` FOREIGN KEY (`vId`) REFERENCES `vendor` (`vId`) ON DELETE NO
ACTION ON UPDATE NO ACTION;

ALTER TABLE `vendor_store`
ADD CONSTRAINT `sid_fk` FOREIGN KEY (`sId`) REFERENCES `store` (`sId`) ON DELETE NO ACTION
ON UPDATE NO ACTION,
ADD CONSTRAINT `vid_fk` FOREIGN KEY (`vId`) REFERENCES `vendor` (`vId`) ON DELETE NO ACTION
ON UPDATE NO ACTION;
