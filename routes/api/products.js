const express = require('express');
const router = express.Router();
const uuid = require('uuid');
var products = require('../../Products');

// @route GET api/products/:id
// @desc Get single product
// @access Public
router.get('/:id', (req, res) => {
    // check if the product exists
    const found = products.some(product => product.id === parseInt(req.params.id));

    if (found) {
        res.json(products.filter(product => product.id === parseInt(req.params.id)));
    } else {
        res.status(400).json({msg: `product ${req.params.id} not found`})
    }
}); 

// @route GET api/products
// @desc Get All products
// @access Public
router.get('/', (req, res) => {
    res.json(products);
});


// @route POST api/products
// @desc Create a product
// @access Public
router.post('/', (req, res) => {

    if (req.body == undefined) {
        console.log(req.body);
        return res.status(400).json({msg: 'Please include all fields'});
    }
    const newProduct = {
        id: uuid.v4(),
        name: req.body.name,
        category: req.body.category,
        price: req.body.price,
        stock: req.body.stock
    }

    // Checks for empty fields in the request body
    if(!newProduct.name || !newProduct.category || !newProduct.price || !newProduct.stock) {
        return res.status(400).json({msg: 'Please include all fields'});
    }
    products.push(newProduct);
    res.json(products);

});

// @route PUT api/products/:id
// @desc Update a product
// @access Public
router.put('/:id', (req, res) => {
    // check if the product exists
    const found = products.some(product => product.id === parseInt(req.params.id));

    if (found) {
        const updProduct = req.body;
        products.forEach(product => {
            // Finds the product to update and updates the fields that are present in the request body
            if(product.id === parseInt(req.params.id)) {
                product.name = updProduct.name ? updProduct.name : product.name;
                product.category = updProduct.category ? updProduct.category : product.category;
                product.price = updProduct.price ? updProduct.price : product.price;
                product.stock = updProduct.stock ? updProduct.stock : product.stock;

                res.json({msg: 'product updated', product});
            }

        
        })
    } else {
        res.status(400).json({msg: `product ${req.params.id} not found`})
    }
});



// @route DELETE api/products/:id
// @desc Delete a product
// @access Public
router.delete('/:id', (req, res) => {
    // check if the product exists
    const found = products.some(product => product.id === parseInt(req.params.id));

    if (found) {

        // delete the product from the array of products based on the id
        products = products.filter(product => product.id !== parseInt(req.params.id));

        res.json({
            msg: 'Product deleted',
            products: products});
    } else {
        res.status(400).json({msg: `product ${req.params.id} not found`})
    }
});


module.exports = router;