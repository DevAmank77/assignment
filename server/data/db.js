
let db = {
  users: [
    { id: 1, username: 'user1', role: 'EndUser' },
    { id: 2, username: 'receiver1', role: 'Receiver' },
  ],
  itemsCatalog: [
    { id: 101, name: 'Laptop' },
    { id: 102, name: 'Mouse' },
    { id: 103, name: 'Keyboard' },
    { id: 104, name: 'Monitor' },
    { id: 105, name: 'Webcam' },
    { id: 106, name: 'Docking Station' },
  ],
  requests: [],
};

let nextRequestId = 1;

module.exports = {
  db,
  getNextRequestId: () => nextRequestId++,
};
