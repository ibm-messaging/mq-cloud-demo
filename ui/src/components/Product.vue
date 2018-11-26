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
  <b-card
    img-fluid
    class="card--custom mt-3 mb-3">
    <div v-on:click="viewProduct(index)">
      <b-card-img
        v-bind:src="productImage"
        v-bind:alt="product.name + ' : ' + product.brand"
        top></b-card-img>
    </div>
    <div slot="header">
      <div class="d-flex">
        <div class="p-2 flex-grow-1">
          <h4> {{product.name}} </h4>
          <small>Manufacturer: {{ product.brand }}</small>
        </div>
        <div class="p-2">
          <h5 class="font-weight-bold">£{{product.price}}</h5>
        </div>
      </div>
    </div>
    <ul class="list-unstyled mt-2">
      <li
        v-for="(spec, key, index) in product.specs"
        v-bind:key="index">
          <div class="d-flex">
            <div class="flex-grow-1">
              {{key | capitalize}}:
            </div>
            <div class="p-2">
              {{spec}}
            </div>
          </div>
        </li>
    </ul>
    <div slot="footer">
      <b-button :to="'products/' + index" variant="primary">View Product</b-button>
    </div>
  </b-card>
</template>

<script>
import router from '../router';

export default {
  name: 'Product',
  props: [
    'product',
    'index'
  ],
  computed: {
    productImage () {
      let image = this.product.id + '.png';
      return require('../assets/products/' + image);
    }
  },
  filters: {
    capitalize: (value) => {
      if (!value) return ''
      value = value.toString()
      return value.charAt(0).toUpperCase() + value.slice(1)
    }
  },
  methods: {
    viewProduct: (index) => {
      router.push('products/' + index);
    }
  }
}
</script>
