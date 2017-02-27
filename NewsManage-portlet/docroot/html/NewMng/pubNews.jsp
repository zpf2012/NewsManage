<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>


<portlet:actionURL var="pubNews" name="pubNews">
	<portlet:param name="mvcPath" value="/html/NewMng/pubNews.jsp"/>
</portlet:actionURL>

<script type="text/javascript">
var editor2;

KindEditor.ready(function(K) {
	editor2 = K.create('textarea[name="newContent"]', {
		cssPath : '<%=request.getContextPath() %>/kindeditor/plugins/code/prettify.css',
		uploadJson : '<%=request.getContextPath() %>/kindeditor/jsp/upload_json.jsp',
		fileManagerJson : '<%=request.getContextPath() %>/kindeditor/jsp/file_manager_json.jsp',
		allowFileManager : true,
		afterBlur : function() {
			this.sync();
			K.ctrl(document, 13, function() {
			K('form[name=newExample]')[0].submit();
			});
			K.ctrl(this.edit.doc, 13, function() {
			K('form[name=newExample]')[0].submit();
			});
		}
	});
	prettyPrint();
});
</script>


<div class="zz_rele">
	<div class="zz_rele_a">

		<div class="zz_rele_d">

			<!-- 发布新闻 -->
			<div id ="nn" class="zz_rele_d_2">
				<form id="form2" name="newExample" method="post" onsubmit="return checkNews();" action="${pubNews }" enctype="multipart/form-data">
					<div class="zz_rele_d_2_a">文章标题</div>
					<div class="zz_rele_d_2_b">
						<input type="text" id="moreTitle" name="newTitle" placeholder="*请输入文章标题（30字以内）必填" style="width: 686px; height: 30px;" />
					</div>
					<div class="zz_rele_d_2_c">文章作者</div>
					<div class="zz_rele_d_2_d">
						<input type="text" id="moreAuthor" name="newSignatureName" placeholder="*请输入文章作者（10字以内）选填" style="width: 686px; height: 30px;"/>
					</div>
					<div class="zz_rele_d_2_e">
						<div class="zz_rele_d_2_e_1">
							<div style=" float: left;">展示图片&nbsp;<span style="font-size: 12px; color :#333333;">作为新闻列表展示用&nbsp;必填一张&nbsp;小于2M</span></div>
<!-- 							<div class="zz_news" style="padding-top: 4px; background-color:#ccc; margin-left: 320px;" onclick="getElementById('picturePath').click()">上传</div>
 -->							<div style="clear:both;"></div>
						</div>
						
						<div class="zz_rele_d_2_e_2">
							<span id="uploadImg"> 
								<input  type="file" size="1" id="picturePath" name="morePicture" style="position:absolute; z-index:100; font-size:0px; opacity:0; filter:alpha(opacity=0); height:170px; width:300px;">
								<img style="width:300px; height:170px;" id="picturePath0" name="picturePath0" src="<%=request.getContextPath() %>/images/clickNews.png">
							</span>	
						</div>
					</div>
					
					<div class="zz_rele_d_2_f">摘要</div>
					<div style="margin-top: 20px;">
						<textarea id="moreSummary" name="newSummary" cols="100" rows="4" style="width:686px; height:100px;" placeholder="*请输入摘要80字以内（选填）    若不填写则从正文中摘取前50字"></textarea>
					</div>
					<div class="zz_rele_d_2_g">正文</div>
					<div style="margin-top: 20px;">
						<textarea id="moreContent" name="newContent" cols="100" rows="8" style="width:696px; height:200px; visibility:hidden;"></textarea>
						<br />
						<input type="submit" id="newSubmit" value="发表新闻" class="zz_sumbit" style="text-align: center; font-size:16px; width:100px; height:28px; padding-top: 2px; font-family: 黑体; margin-bottom: 40px;"/><span>${messageNews }</span>
					</div>
				</form>
			</div>

		</div>
	</div>
</div>




<script type="text/javascript">
$(function(){
	//图片上传并预览
	$("#picturePath").change(function () {
	    var pathName = $("input[name='morePicture']").val();
	    //alert(pathName);//C:\fakepath\P51226-115809.jpg
	    var index = pathName.lastIndexOf('\\');//前面的反斜杆是转义的作用
	    var fileName = pathName.substring(index + 1, pathName.length);//得到文件名
	    var reader = new FileReader();
	    reader.readAsDataURL(this.files[0]);//DataURL是一项特殊的技术，可以将该文件this.files[0]内嵌在网页之中
	    //通过给reader监听一个onload事件，将数据加载完毕后，在onload事件处理中，通过reader的result属性即可获得文件内容
	    /* reader.onload = function (e) {
	        var tempfile = this.result;//获得文件内容
	        var data = {
	            file: tempfile,
	            fileType: "image",
	            fileName: fileName
	        };
	      	//预览图片
	        $("#picturePath0").attr("src", tempfile);
	    } */
	    //图片限于bmp,png,gif,jpeg,jpg格式
        var extStart = pathName.lastIndexOf(".");
        var ext = pathName.substring(extStart, pathName.length).toUpperCase();//得到文件格式
        if (ext != ".BMP" && ext != ".PNG" && ext != ".GIF" && ext != ".JPG" && ext != ".JPEG") {
            alert("图片限于bmp,png,gif,jpeg,jpg格式");
            return false;
        } 
        else {
			var file_size = 0;
			file_size = this.files[0].size;//单位是B
            var size = file_size / 1024;//单位是KB
            if (size > 2048) {
                alert("上传的图片大小不能超过2M！");
            } 
            else {
          		//格式正常后加载预览
            	reader.onload = function (e) {
        	        var tempfile = this.result;//获得文件内容
        	        var data = {
        	            file: tempfile,
        	            fileType: "image",
        	            fileName: fileName
        	        };
        	      	//预览图片
        	        $("#picturePath0").attr("src", tempfile);
        	    }
            }
        }
        //以上关于图片的上传要求
	});	
});



/* 验证发布新闻的内容 */
var checkNews = function(){
	var flag=true;
	var moreTitle=document.getElementById('moreTitle').value;
	var picturePath=document.getElementById('picturePath').value;
	var moreContent=document.getElementById('moreContent').value;
	var moreSummary=document.getElementById('moreSummary').value;
	if($.trim(moreTitle)==''){
		alert('未输入标题');
		flag=false;
	}
	else if(moreTitle.length>30){
		alert('标题字数过长');
		flag=false;
	}
	else if(picturePath==''){
		alert('您没有选择图片上传!');
		flag=false;
	}
	else if(moreSummary.length>80){
		alert('摘要字数过长');
		flag=false;
	}
	else if($.trim(moreContent)==''){
		alert('未填写主要内容');
		flag=false;
	}
	else{
		flag=true;
	}
	return flag;
}

</script>