USE [2019]
GO
/****** Object:  StoredProcedure [dbo].[plhy_bak]    Script Date: 08/05/2020 11:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[plhy_bak] 
@nd_max VARCHAR(10)
as
declare 
	@nd_min VARCHAR(10)=2019,@DBMC VARCHAR(255),@DBJ3 VARCHAR(MAX),@sql VARCHAR(MAX),@dbmc2 VARCHAR(max),@sql2 VARCHAR(MAX),@nd varchar(10),@dwmc VARCHAR(255)
BEGIN
	CREATE TABLE #TB1
	( DBMC VARCHAR(MAX) ,
	  DBJ1 bit ,
	  DBJ2 INT ,
	DBJ3 VARCHAR(MAX))
  
	INSERT INTO #TB1(DBMC,DBJ1,DBJ2) exec master..xp_dirtree 'E:\小蜜蜂备份数据\最近\',1,1

--SELECT * FROM #TB1

	DECLARE _c2 CURSOR FOR SELECT dbmc FROM #tb1
	OPEN _c2
	FETCH NEXT FROM _c2 INTO @dbmc
		
	while @@FETCH_STATUS=0 begin 
		
		CREATE TABLE #TB2
		( DBMC VARCHAR(MAX) ,
		  DBJ1 bit ,
		  DBJ2 INT ,
		  DBJ3 VARCHAR(MAX))
		SET @sql2='INSERT INTO #TB2(DBMC,DBJ1,DBJ2) exec master..xp_dirtree '+''''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+''''+',1,1'
		EXEC(@sql2)
		update #TB2 set dbj3=left(dbmc,charindex('_',dbmc)-1)
				
		declare _c1 cursor for select dbmc, dbj3 from #tb2
			open _c1
			fetch next from _c1 into @DBMC2, @DBJ3
			while @@FETCH_STATUS=0 begin
			begin try
				--RESTORE DATABASE [013051四明山镇初级中学] FROM DISK='E:\小蜜蜂备份数据\最近\四明山\daysqlbak\013051四明山镇初级中学_backup_2020_04_20_230001_6662055.bak';
				set @sql='RESTORE DATABASE ['+@dbj3+'] FROM DISK='''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''''+' with replace,MOVE '+''''+'2019政府会计制度（小蜜蜂）全'+''''+' TO '+''''+'D:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\'+@dbj3+'.mdf'+''''+',MOVE '+''''+'2019政府会计制度（小蜜蜂）全_log'+''''+' TO '+''''+'D:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\'+@dbj3+'.ldf'+''''
				exec(@sql)
				SET @nd=@nd_min
				while @nd<=@nd_max begin
					INSERT INTO LOG SELECT 'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2,@nd,'成功',convert(varchar,getdate(),120),'成功','成功','成功','成功','成功','成功','成功','成功','成功','成功'
			--k1all
					begin try
						SET @sql='INSERT INTO [2019].[dbo].[K1ALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001K1] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set k1='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--k3all
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[K3ALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001K3] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set k3='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--k4all
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[K4ALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001K4] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set k4='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--k8all
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[K8ALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001K8] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set k8='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--kcall
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[KcALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001Kc] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set kc='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--keall
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[KeALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001Ke] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set ke='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--kiall
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[KiALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001Ki] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try	
					begin catch
						update log set ki='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--pzall
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[pzALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001p2] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set p2='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--pzmxall
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[pzmxALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',a.*
										  FROM ['+@dbj3+'].[dbo].['+@nd+'001p1] a join ['+@dbj3+'].[dbo].[SYS000] ON 1=1 WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set p1='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
			--sysall
					begin try
						SET @sql= 'INSERT INTO [2019].[dbo].[sysALL] SELECT '''+'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2+''',NULL,name,'+@nd+',dmcd0,null,null,null'+
										  ' FROM ['+@dbj3+'].[dbo].[SYS000] WHERE FIcCurYear IS NOT NULL;' 
						exec(@sql)
					end try
					begin catch
						update log set sys='失败',stas='失败' where nd=@nd and name='E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2
					end catch
					set @nd=@nd+1
				end
				set @sql='drop database ['+@dbj3+']'
				exec(@sql)
			end try 
			begin catch
				SET @nd=@nd_min
				while @nd<=@nd_max begin
				INSERT INTO LOG SELECT 'E:\小蜜蜂备份数据\最近\'+@dbmc+'\daysqlbak\'+@dbmc2,@nd,'失败',convert(varchar,getdate(),120),'失败','失败','失败','失败','失败','失败','失败','失败','失败','失败'
				set @nd=@nd+1
				end
			end catch
			fetch next from _c1 into @DBMC2, @DBJ3
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