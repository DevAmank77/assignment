const { db, getNextRequestId } = require('../data/db');

exports.loginUser = (req, res) => {
  const { username } = req.body;
  const user = db.users.find(u => u.username === username);

  if (user) {
    console.log(`[AUTH] User '${username}' successfully logged in.`);
    res.status(200).json(user);
  } else {
    console.log(`[AUTH] Failed login attempt for username: '${username}'.`);
    res.status(404).json({ message: 'User not found' });
  }
};

exports.getItems = (req, res) => {
  res.status(200).json(db.itemsCatalog);
};

exports.createRequest = (req, res) => {
  const { userId, itemIds } = req.body;

  if (!userId || !itemIds || !Array.isArray(itemIds) || itemIds.length === 0) {
    return res.status(400).json({ message: 'User ID and a non-empty array of item IDs are required.' });
  }

  const newRequest = {
    id: getNextRequestId(),
    userId: parseInt(userId),
    status: 'Pending',
    items: itemIds.map(id => ({
      itemId: id,
      name: db.itemsCatalog.find(i => i.id === id)?.name || 'Unknown Item',
      confirmed: null
    })),
    assignedTo: 2
  };

  db.requests.push(newRequest);
  console.log(`[REQUEST] New request #${newRequest.id} created by User #${userId}.`);
  res.status(201).json(newRequest);
};

exports.getRequests = (req, res) => {
  const { role, userId } = req.query;
  const parsedUserId = parseInt(userId);

  if (!role || !userId) {
    return res.status(400).json({ message: 'Role and userId query parameters are required.' });
  }

  let results = [];
  if (role === 'EndUser') {
    results = db.requests.filter(r => r.userId === parsedUserId);
  } else if (role === 'Receiver') {
    results = db.requests.filter(r => r.assignedTo === parsedUserId && r.status === 'Pending');
  }

  res.status(200).json(results);
};

exports.confirmRequest = (req, res) => {
    const requestId = parseInt(req.params.id);
    const { confirmations } = req.body;
    const requestIndex = db.requests.findIndex(r => r.id === requestId);
  
    if (requestIndex === -1) {
      return res.status(404).json({ message: 'Request not found.' });
    }
  
    const request = db.requests[requestIndex];
    if (request.status !== 'Pending') {
        return res.status(400).json({ message: 'This request has already been processed.' });
    }
  
    const unconfirmedItems = [];
  
    request.items.forEach(item => {
      const confirmation = confirmations.find(c => c.itemId === item.itemId);
      if (confirmation && confirmation.confirmed === false) {
          unconfirmedItems.push(item);
      } else if (!confirmation) {
          unconfirmedItems.push(item);
      }
      if(confirmation){
          item.confirmed = confirmation.confirmed;
      }
    });
  
    if (unconfirmedItems.length === 0) {
      request.status = 'Confirmed';
      console.log(`[REQUEST] Request #${request.id} status updated to 'Confirmed'.`);
    } else {
      request.status = 'Partially Fulfilled';
      console.log(`[REQUEST] Request #${request.id} status updated to 'Partially Fulfilled'.`);
  
      const newRequest = {
        id: getNextRequestId(),
        userId: request.userId,
        status: 'Pending',
        items: unconfirmedItems.map(item => ({ ...item, confirmed: null })),
        assignedTo: 2
      };
      db.requests.push(newRequest);
      console.log(`[REQUEST] Unconfirmed items from #${request.id} reassigned to new request #${newRequest.id}.`);
    }
  
    db.requests[requestIndex] = request;
    res.status(200).json(request);
};
