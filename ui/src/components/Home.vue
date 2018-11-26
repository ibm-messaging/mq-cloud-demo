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
  <div id="home">
    <!-- top two product listings -->
    <!-- products -->
    <div class="container">
      <div class="mt-3">
        <div class="d-flex flex-column">
          <h1>Our Top Selling Products</h1>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <div class="card-deck">
            <Product
            v-bind:product="products[0]"
            v-bind:index="0"
            v-bind:key="0"
            ></Product>
            <Product
            v-bind:product="products[1]"
            v-bind:index="1"
            v-bind:key="1"
            ></Product>
          </div>
        </div>
      </div>
    </div>
    <!-- end-products -->
  </div>
</template>

<script>
import Product from './Product.vue';
import products from '../data/non_branded_products.json';

export default {
  name: 'Home',
  data () {
    return {
      products
    }
  },
  components: {
    Product
  }
}
</script>
