define([], function () {
  'use strict';

  return {
    town: {
      title: 'Town of Pylaim',
      desc: 'You take a look around the town. You see weapon and armour shops plus a general store. On the other side of town you see a monitor station and a fortune tellers tent.',
      actions: [
        { label: 'Weapon Shop' },
        { label: 'Armour Shop' },
        { label: 'General Store' },
        { label: 'Monitor Station' },
        { label: 'Fortune Teller' },
        { label: 'Leave town' }
      ]
    },
    monitor: {
      title: 'Monitor Station',
      desc: 'This used to be where you would go to get your stats, however you can see those on the right hand side now.',
      actions: [
        { label: 'Leave station' }
      ]
    },
    grassland: {
      title: 'Grassland',
      desc: 'The mist settles and you find yourself in a grassy field. There is a town nearby. The field is bordered on the West by a dense forest. There seems to be a powerful negative aura given off by the forest. You decide to stay out of the forest for the time being. To the East is a barren rocky area. This is some strange terrain, you think to yourself.',
      actions: []
    },
    rockyland: {
      title: 'Rocky land',
      desc: '',
      actions: []
    }
  };
});