<!--
 * © Copyright IBM Corporation 2018
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
-->
<template>
  <div class="container flex-grow-1">
    <div class="mt-3">
      <div class="d-flex flex-column">
        <h1>Product Catalog</h1>
        <p>{{msg}}</p>
      </div>
    </div>
    <div class="mt-2">
      <div class="card-deck">
        <Product
        v-for="(product, index) in products"
        v-bind:product="product"
        v-bind:index="index"
        v-bind:key="index"
        >
        ></Product>
      </div>
    </div>
  </div>
</template>

<script>
import Product from './Product.vue';
import products from '../data/non_branded_products.json';

export default {
  name: 'Products',
  data () {
    return {
      title: 'Catalog',
      msg: 'We sell a wide range of mobile products',
      products
    }
  },
  components: {
    Product
  }
}
</script>
