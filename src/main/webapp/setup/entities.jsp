<%-- 
    Document   : index
    Created on : May 28, 2013, 11:20:32 AM
    Author     : sernadela
--%>

<%@include file="/layout/taglib.jsp" %>
<s:layout-render name="/setup/html.jsp">
    <s:layout-component name="title">COEUS Setup</s:layout-component>
    <s:layout-component name="custom_scripts">
        <script src="<c:url value="/assets/js/jquery.js" />"></script>
        <script src="<c:url value="/assets/js/coeus.sparql.js" />"></script>
        <script src="<c:url value="/assets/js/coeus.api.js" />"></script>
        <script type="text/javascript">

            function selectEntity(entity) {
                $('#removeModalLabel').html('coeus:entity_' + entity.split(' ').join('_'));
            }
            function removeEntity() {
                var entity = $('#removeModalLabel').html();
                //var query = initSparqlerQuery();
                console.log('Remove: ' + entity);

                var urlPrefix = "../../api/" + getApiKey();
                //remove all subjects and predicates associated.
                removeAllTriplesFromObject(urlPrefix, entity);
                //remove all predicates and objects associated.            
                removeAllTriplesFromSubject(urlPrefix, entity);

            }

            $(document).ready(function() {
                var seed = lastPath();
                var query = initSparqlerQuery();
                // passes standard JSON results object to success callback
                var qEntities = "SELECT DISTINCT ?entity ?e {" + seed + " coeus:includes ?entity . ?entity dc:title ?e . }";

                query.query(qEntities,
                        {success: function(json) {
                                // fill Entities

                                for (var key = 0, size = json.results.bindings.length; key < size; key++) {
                                    var a = '<tr><td><a href=' + json.results.bindings[key].entity.value + '>'
                                            + json.results.bindings[key].entity.value + '</a></td><td>'
                                            + json.results.bindings[key].e.value + '</td><td>'
                                            + '<div class="btn-group">'
                                            + '<a class="btn btn" href="../entity/edit/coeus:' + splitURIPrefix(json.results.bindings[key].entity.value).value + '">Edit</a>'
                                            + '<button class="btn btn" href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</button>'
                                            + '</div>'
                                            + ' <a class="btn btn-info" href="../concept/coeus:' + splitURIPrefix(json.results.bindings[key].entity.value).value + '">View Concepts</a>'
                                            //+ '<a href="#removeModal" role="button" data-toggle="modal" onclick="selectEntity(\'' + json.results.bindings[key].e.value + '\')">Remove</a>'
                                            + '</td></tr>';
                                    $('#entities').append(a);

                                }



                            }}
                );
                //header name
                var path = lastPath();
                $('#header').append('<h1>' + path + '<small> env.. </small></h1>');
                $('#breadSeed').html('<a href="../seed/'+path+'">Seed</a> <span class="divider">/</span>');
                
                var urlPrefix = "../../api/" + getApiKey();
                cleanUnlikedTriples(urlPrefix);
            });
        </script>
    </s:layout-component>
    <s:layout-component name="body">

        <div class="container">
            <br><br>
            <div id="header" class="page-header">

            </div>

            <ul class="breadcrumb">
                <li id="breadSeed"></li>
                <li class="active">Entities</li>
            </ul>
            <div class="row-fluid">

                <div class="span6">
                    <h3>List of Entities</h3>
                </div>


                <div class="span6 text-right" >
                    <div class="btn-group">
                        <a onclick="redirect('../entity/add/' + lastPath())" class="btn btn-success">Add Entity</a>
                    </div>
                </div>


                <table class="table table-hover">

                    <thead>
                        <tr>
                            <th>Entity</th>
                            <th>Title</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="entities">

                    </tbody>
                </table>

                <!-- Button to trigger modal -->


                <!-- Modal -->
                <div id="removeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                        <button id="closeRemoveModal" type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h3 >Remove Entity</h3>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure do you want to remove the <strong><a class="text-error" id="removeModalLabel"></a></strong> entity?</p>
                        <p class="text-warning">Warning: All dependents triples are removed too.</p>

                        <div id="result">

                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                        <button class="btn btn-danger" onclick="removeEntity();">Remove</button>
                    </div>
                </div>

            </div>

        </s:layout-component>
    </s:layout-render>
