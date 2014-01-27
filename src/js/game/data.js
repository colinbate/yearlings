define(['game/locations/index'], function (locations) {
  'use strict';

  return {
    enemy: {
      grass: [
        { name: 'Wolf',        hitPoints: 19, money:  50, experience:  30 },
        { name: 'Imp',         hitPoints:  8, money:  20, experience:  12 },
        { name: 'Geist',       hitPoints: 40, money: 100, experience:  61 },
        { name: 'Warlock',     hitPoints: 23, money:  60, experience:  35 },
        { name: 'Fox',         hitPoints: 11, money:  30, experience:  20 },
        { name: 'Xas',         hitPoints: 37, money:  90, experience:  52 },
        { name: 'Rat',         hitPoints:  5, money:  10, experience:   7 },
        { name: 'Mongoose',    hitPoints: 15, money:  40, experience:  25 },
        { name: 'Bear',        hitPoints: 32, money:  80, experience:  50 },
        { name: 'Goblin',      hitPoints: 26, money:  70, experience:  42 }
      ],
      rocky: [
        { name: 'druid',       hitPoints: 41, money:  88, experience:  60 },
        { name: 'demon',       hitPoints: 52, money: 105, experience:  75 },
        { name: 'dactyl',      hitPoints: 67, money: 130, experience: 100 },
        { name: 'dragon',      hitPoints: 87, money: 170, experience: 125 },
        { name: 'T-Rex',       hitPoints: 75, money: 150, experience: 115 },
        { name: 'ogre',        hitPoints: 71, money: 142, experience: 105 },
        { name: 'troll',       hitPoints: 60, money: 125, experience:  85 },
        { name: 'sidewinder',  hitPoints: 99, money: 200, experience: 150 },
        { name: 'cave monkey', hitPoints: 59, money: 120, experience:  90 },
        { name: 'paramanthis', hitPoints: 30, money: 250, experience:  10 }
      ],
      morlin: {
        name: 'Morlin',
        hitPoints: 110,
        money: 10,
        experience: 200,
        boss: true
      },
      kamul: {
        name: 'Kamul',
        hitPoints: 180,
        money: 0,
        experience: 0,
        boss: true,
        noBomb: true
      }
    },
    weapon: [
      { name: 'Rapier',        price: 150,  strength:  3 },
      { name: 'Phantom Blade', price: 300,  strength:  7 },
      { name: 'Katana',        price: 550,  strength: 10 },
      { name: 'eXaliber',      price: 800,  strength: 15 },
      { name: 'Masemune',      price: 1150, strength: 21 },
      { name: 'Dragon\'s Bane',price: 0,    strength: 33 }
    ],
    armor: [
      { name: 'Aura Coat',     price: 200,  strength:  2 },
      { name: 'Chain Mail',    price: 300,  strength:  5 },
      { name: 'Plate Mail',    price: 450,  strength:  9 },
      { name: 'Dragon Torso',  price: 600,  strength: 13 },
      { name: 'Diamond Suit',  price: 800,  strength: 18 }
    ],
    items: [
      { name: 'Cure potion',     price: 10 },
      { name: 'Bomb',            price: 15 },
      { name: 'Save your game',  price:  5 },
      { name: 'Spend the night', price: 35 }
    ],
    levels: [90, 210, 400, 630, 900, 1200, 1550, 1950, 2400, 2900, 3450, 4050, 4700, 5400, 6200],
    locations: locations
  };
});