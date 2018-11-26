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
        <div class="d-flex flex-row">
          <div class="pt-2 mr-3">
            <router-link
              to="/products"
              v-b-tooltip.hover.bottom="'Go Back to Products Page'"
              class="back-button">
              <font-awesome-icon :icon="['fas', 'arrow-left']" />
            </router-link>
          </div>
          <div class="flex-grow-1">
            <h1> {{product.name}} </h1>
            <p>Manufacturer: {{ product.brand }}</p>
          </div>
        </div>
      </div>
    </div>
    <div class="d-flex flex-row flex-wrap mb-4">
      <div class="col-sm-4 pt-3 pl-0 pr-0">
        <b-img thumbnail fluid v-bind:src="productImage" alt="Thumbnail"/>
      </div>
      <div class="col-sm-8 pr-0 pr-0">
        <div class="col-sm-8 p-2">
          <h2>Specifications:</h2>
          <ul class="list-unstyled">
            <li
              v-for="(spec, key, index) in product.specs"
              v-bind:key="index">
              <div class="d-flex">
                <div class="flex-grow-1">
                  {{key | capitalize}}:
                </div>
                <div class="p-2 align-self-end">
                  {{spec}}
                </div>
              </div>
            </li>
          </ul>
        </div>
        <stock-check class="mt-2" :product="product"></stock-check>
      </div>
    </div>
  </div>
</template>

<script>
  import products from '../data/non_branded_products.json';
  import fa from '../shared/vue_fa';

  export default {
    name: 'ProductPage',
    props: [
      'id'
    ],
     components: {
      fa
    },
    data: function () {
      return {
        product: products[this.id],
        location: ''
      }
    },
    filters: {
      capitalize: (value) => {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      }
    },
    computed: {
      productImage () {
        let image = this.product.id + '.png';
        return require('../assets/products/' + image);
      }
    }
  }
</script>
