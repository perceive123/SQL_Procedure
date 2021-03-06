USE [2015]
GO
/****** Object:  StoredProcedure [dbo].[plhy_bac_year]    Script Date: 08/05/2020 11:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery21.sql|7|0|C:\Users\Administrator\AppData\Local\Temp\~vsBCEA.sql
create proc [dbo].[plhy_bac_year]
@nd_min VARCHAR(10),
@nd_max VARCHAR(10)
as
declare 
	@DBMC VARCHAR(20),@sql VARCHAR(max),@dbmc2 VARCHAR(255),@sql2 VARCHAR(max),@nd varchar(10),@dbmc3 VARCHAR(255),@dwmc varchar(255),@DBJ2 varchar(1),@flag bit
BEGIN
	CREATE TABLE #TB1
	( DBMC VARCHAR(20) ,
	  DBJ1 int ,
	  DBJ2 INT )
  
	INSERT INTO #TB1(DBMC,DBJ1,DBJ2) exec master..xp_dirtree 'E:\小蜜蜂备份数据\最近\',1,1

	DECLARE _c2 CURSOR FOR SELECT dbmc FROM #tb1
	OPEN _c2
	FETCH NEXT FROM _c2 INTO @dbmc
		
	while @@FETCH_STATUS=0 begin 
		
		CREATE TABLE #TB2
		( DBMC VARCHAR(255) ,
		  DBJ1 bit ,
		  DBJ2 INT )
		SET @sql2='INSERT INTO #TB2(DBMC,DBJ1,DBJ2) exec master..xp_dirtree '+''''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+''''+',1,1'
		EXEC(@sql2)
		
		declare _c1 cursor for select dbmc,dbj2 from #tb2
			open _c1
			fetch next from _c1 into @DBMC2,@dbj2
			while @@FETCH_STATUS=0 BEGIN
				--如果是文件夹
				IF @dbj2=0 begin
				CREATE TABLE #TB3
				( DBMC VARCHAR(255) ,
				  DBJ1 INT ,
				  DBJ2 INT)
				set @sql='INSERT INTO #TB3(DBMC,DBJ1,DBJ2) exec master..xp_dirtree '+''''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''''+',1,1'
				exec(@sql)
								
				declare _c3 cursor for select dbmc from #tb3
				open _c3
				fetch next from _c3 into @DBMC3
				while @@FETCH_STATUS=0 BEGIN		
				--获取sys000表中的单位名称
					CREATE TABLE #TB4
					(fyear varchar(5),dwmc VARCHAR(255),flag bit)
					begin try
					SET @sql='insert into #tb4 select FIcCurYear,name,1 FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...[sys000] where FIcCurYear is not null'
					EXEC(@sql)
					select @nd=fyear,@dwmc=dwmc from #tb4
					SET @nd=@nd_min
					while @nd<=@nd_max begin
						INSERT INTO LOG SELECT 'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3,@nd,'成功',convert(varchar,getdate(),120),'成功','成功','成功','成功','成功','成功','成功','成功','成功','成功'
						UPDATE #TB4 SET flag=1
				--k1all
						begin try
							SET @sql='insert INTO [2015].[dbo].[K1ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001k1] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k1='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--k3all
						begin try
							SET @sql='insert INTO [2015].[dbo].[k3ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001k3] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k3='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--k4all
						begin try
							SET @sql='insert INTO [2015].[dbo].[k4ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',KHBH,KHName,JC,KHGroup,KHTel,KHTel_1,KHFax,POST,KHDbgh,KHAddr,KHLXR,KHFR,QYXZ,QYSH,BANK,YHZH,BANK_1,YHZH_1,XYDJ,XYje,QT,taxid,CZ,EMAIL,fdisc FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001k4] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k4='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--k8all
						begin try
							SET @sql='insert INTO [2015].[dbo].[k8ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',KMBM,KMMC,KMLB,ZBXS,YEFX,WBZL,TBKM,JLDW,YNXJ,USE_KH,USE_BM,USE_ZY,JZXN,KHGroup,null,JC,YNNC,YNNYS,YNGQ FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001k8] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k8='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--kiall
						begin try
							SET @sql='insert INTO [2015].[dbo].[kiALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001ki] a'
							EXEC(@sql)
						end try
						begin catch
							update log set ki='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--kcall
						begin try
							SET @sql='insert INTO [2015].[dbo].[kcALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001kc] a'
							EXEC(@sql)
						end try
						begin catch
							update log set kc='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--keall
						begin try
							SET @sql='insert INTO [2015].[dbo].[keALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001ke] a'
							EXEC(@sql)
						end try
						begin catch
							update log set ke='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--pzall
						begin try
							SET @sql='insert INTO [2015].[dbo].[pzALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',yue,lb,pdh,fjzs,jzr,xgr,shr,fch,pzly,CurMonth,master,delegate,Cn,BookBy,ImageID FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001p2] a'
							EXEC(@sql)
						end try
						begin catch
							update log set p2='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--pzmxall
						begin try
							SET @sql='insert INTO [2015].[dbo].[pzmxALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',yue,zpdh,lb,pdh,bh,ri,zy,kmh,wbzl,jd,je,wbje,sl,dzh,dzbz,khbm,bmbm,zybm,jsfsbm,ywbh,fdate,Cashid,CurMonth,ExChRate,UnitPrice,PZXZ FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...['+@nd+'001p1] a'
							EXEC(@sql)
						end try
						begin catch
							update log set p1='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
							UPDATE #tb4 SET flag=0
						end catch
				--sysall
						SELECT @flag=flag from #tb4
						IF @flag=1 begin
						begin try
							SET @sql='insert INTO [2015].[dbo].[sysALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+''',NULL,'''+@dwmc+''','+@nd+',dmcd0,null,null,null FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3+
									'";User ID=Admin'''+')...[sys000] where FIcCurYear is not null'
							EXEC(@sql)
						end try
						begin catch
							update log set sys='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3
						end CATCH
						end
						set @nd=@nd+1
					end
					end try
					begin catch
					INSERT INTO LOG SELECT 'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+'\'+@dbmc3,'*','失败',convert(varchar,getdate(),120),'失败','失败','失败','失败','失败','失败','失败','失败','失败','失败'
					end catch	
					drop table #tb4
					fetch next from _c3 into @DBMC3	
					end
					close _c3
					deallocate _c3
					drop table #tb3
				END 
				--如果是文件
				ELSE BEGIN 
					CREATE TABLE #TB5
					(fyear varchar(5),dwmc VARCHAR(255),flag bit)
					begin try
					SET @sql='insert into #TB5 select FIcCurYear,name,1 FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...[sys000] where FIcCurYear is not null'
					EXEC(@sql)
					select @nd=fyear,@dwmc=dwmc from #TB5
					SET @nd=@nd_min
					while @nd<=@nd_max begin
						INSERT INTO LOG SELECT 'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2,@nd,'成功',convert(varchar,getdate(),120),'成功','成功','成功','成功','成功','成功','成功','成功','成功','成功'
						UPDATE #TB5 SET flag=1
				--k1all
						begin try
							SET @sql='insert INTO [2015].[dbo].[K1ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001k1] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k1='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--k3all
						begin try
							SET @sql='insert INTO [2015].[dbo].[k3ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001k3] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k3='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--k4all
						begin try
							SET @sql='insert INTO [2015].[dbo].[k4ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',KHBH,KHName,JC,KHGroup,KHTel,KHTel_1,KHFax,POST,KHDbgh,KHAddr,KHLXR,KHFR,QYXZ,QYSH,BANK,YHZH,BANK_1,YHZH_1,XYDJ,XYje,QT,taxid,CZ,EMAIL,fdisc FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001k4] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k4='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #tb5 SET flag=0
						end catch
				--k8all
						begin try
							SET @sql='insert INTO [2015].[dbo].[k8ALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',KMBM,KMMC,KMLB,ZBXS,YEFX,WBZL,TBKM,JLDW,YNXJ,USE_KH,USE_BM,USE_ZY,JZXN,KHGroup,null,JC,YNNC,YNNYS,YNGQ FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001k8] a'
							EXEC(@sql)
						end try
						begin catch
							update log set k8='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--kiall
						begin try
							SET @sql='insert INTO [2015].[dbo].[kiALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001ki] a'
							EXEC(@sql)
						end try
						begin catch
							update log set ki='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--kcall
						begin try
							SET @sql='insert INTO [2015].[dbo].[kcALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001kc] a'
							EXEC(@sql)
						end try
						begin catch
							update log set kc='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--keall
						begin try
							SET @sql='insert INTO [2015].[dbo].[keALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',a.* FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001ke] a'
							EXEC(@sql)
						end try
						begin catch
							update log set ke='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--pzall
						begin try
							SET @sql='insert INTO [2015].[dbo].[pzALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',yue,lb,pdh,fjzs,jzr,xgr,shr,fch,pzly,CurMonth,master,delegate,Cn,BookBy,ImageID FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001p2] a'
							EXEC(@sql)
						end try
						begin catch
							update log set p2='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--pzmxall
						begin try
							SET @sql='insert INTO [2015].[dbo].[pzmxALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',yue,zpdh,lb,pdh,bh,ri,zy,kmh,wbzl,jd,je,wbje,sl,dzh,dzbz,khbm,bmbm,zybm,jsfsbm,ywbh,fdate,Cashid,CurMonth,ExChRate,UnitPrice,PZXZ FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...['+@nd+'001p1] a'
							EXEC(@sql)
						end try
						begin catch
							update log set p1='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
							UPDATE #TB5 SET flag=0
						end catch
				--sysall
						SELECT @flag=flag from #TB5
						IF @flag=1 begin
						begin try
							SET @sql='insert INTO [2015].[dbo].[sysALL] Select '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+''',NULL,'''+@dwmc+''','+@nd+',dmcd0,null,null,null FROM OPENDATASOURCE('+
									'''Microsoft.ACE.OLEDB.12.0'''+','''+
									'Data Source='+'"E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2+
									'";User ID=Admin'''+')...[sys000] where FIcCurYear is not null'
							EXEC(@sql)
						end try
						begin catch
							update log set sys='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2
						end CATCH
						end
						set @nd=@nd+1
					end
					end try
					begin catch
					INSERT INTO LOG SELECT 'E:\小蜜蜂备份数据\最近\'+@dbmc+'\xmfdata\'+@dbmc2,'*','失败',convert(varchar,getdate(),120),'失败','失败','失败','失败','失败','失败','失败','失败','失败','失败'
					end catch	
					drop table #TB5									
				END
				--如果是文件
				fetch next from _c1 into @DBMC2,@DBJ2		
		end
		close _c1
		deallocate _c1
		drop table #tb2
	FETCH NEXT FROM _c2 INTO @dbmc
	END
	close _c2
	deallocate _c2
END
drop table #tb1