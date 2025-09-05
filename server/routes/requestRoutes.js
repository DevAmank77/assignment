const express = require('express');
const router = express.Router();
const controller = require('../controllers/requestController');


router.post('/login', controller.loginUser);

router.get('/items', controller.getItems);
router.post('/requests', controller.createRequest);
router.get('/requests', controller.getRequests);
router.put('/requests/:id/confirm', controller.confirmRequest);

module.exports = router;
