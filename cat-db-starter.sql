CREATE TABLE `wop_cat` (
  `cat_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `weight` float NOT NULL,
  `owner` int(11) NOT NULL,
  `filename` text NOT NULL,
  `birthdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wop_cat` (`cat_id`, `name`, `weight`, `owner`, `filename`, `birthdate`) VALUES
(1, 'Frank', 5, 1, 'http://placekitten.com/400/300', '2010-08-04'),
(2, 'Jessie', 3.5, 3, 'http://placekitten.com/400/302', '2020-11-03'),
(3, 'Garfield', 11, 2, 'http://placekitten.com/400/304', '1978-02-12');

CREATE TABLE `wop_user` (
  `user_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `role` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wop_user` (`user_id`, `name`, `email`, `password`, `role`) VALUES
(1, 'admin', 'admin@metropolia.fi', 'asdf', 0),
(2, 'Jane Doez', 'jane@metropolia.fi', 'qwer', 1),
(3, 'John Doe', 'john@metropolia.fi', '1234', 1);

ALTER TABLE `wop_cat`
  ADD PRIMARY KEY (`cat_id`),
  ADD KEY `owner` (`owner`);

ALTER TABLE `wop_user`
  ADD PRIMARY KEY (`user_id`);

ALTER TABLE `wop_cat`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `wop_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `wop_cat`
  ADD CONSTRAINT `wop_cat_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `wop_user` (`user_id`) ON DELETE CASCADE;
