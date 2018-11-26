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
  <div class="app" id="app">
    <b-navbar class="navbar--tech" type="dark" toggleable="md">
      <div class="container">
        <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

        <b-navbar-brand href="#/">Company Name</b-navbar-brand>

        <b-collapse is-nav id="nav_collapse">

          <b-navbar-nav>
            <li class="nav-item">
              <router-link class="nav-link" to="/products">Products</router-link>
            </li>
          </b-navbar-nav>

        </b-collapse>
      </div>
    </b-navbar>
    <div class="main d-flex flex-column">
    <router-view/>
    <footer class="footer">
      <div class="container">
        <div class="row mt-3">
           <div class="col-sm-12">
            <h5><small>Mobiles, Tablets, and more.</small></h5>
          </div>
        </div>
      </div>
    </footer>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>
