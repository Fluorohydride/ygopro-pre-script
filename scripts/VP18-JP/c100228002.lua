--熾天龍 ジャッジメント
--Judgment, the Seraphic Dragon
--Script by dest
function c100228002.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c100228002.syncon)
	e1:SetTarget(c100228002.syntg)
	e1:SetOperation(c100228002.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(100228002,0))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100228002.condition)
	e2:SetCost(c100228002.cost)
	e2:SetTarget(c100228002.target)
	e2:SetOperation(c100228002.operation)
	c:RegisterEffect(e2)
	--discard deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(100228002,1))
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100228002.condition2)
	e3:SetTarget(c100228002.target2)
	e3:SetOperation(c100228002.operation2)
	c:RegisterEffect(e3)
end
function c100228002.ntfilter(c,att)
	return c:IsNotTuner() and c:IsAttribute(att)
end
function c100228002.synfilter1(c,syncard,mg,smat)
	local g=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_SMATERIAL)
	local att=nil
	if g:GetCount()>0 then
		att=g:GetFirst():GetAttribute()
		if g:GetCount()>1 then
			for tc in aux.Next(g) do
				if tc:GetAttribute()~=att then return false end
			end
		end
	end
	return c:IsType(TYPE_TUNER) and (not att or c:IsAttribute(att))
		and mg:IsExists(c100228002.synfilter2,1,nil,syncard,mg,smat,c,c:GetAttribute())
end
function c100228002.synfilter2(c,syncard,mg,smat,c1,att)
	local sg=Group.CreateGroup()
	sg:AddCard(c1)
	local mg2=mg:Clone()
	mg2=mg:Filter(c100228002.ntfilter,nil,att)
	return aux.SynMixCheck(mg2,sg,1,99,syncard,smat)
end
function c100228002.syncon(e,c,smat,mg1)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if mg1 then
		mg=mg1
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	return mg:IsExists(c100228002.synfilter1,1,nil,c,mg,smat)
end
function c100228002.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
	local g=Group.CreateGroup()
	local mg
	if mg1 then
		mg=mg1
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local c1=mg:FilterSelect(tp,c100228002.synfilter1,1,1,nil,c,mg,smat):GetFirst()
	g:AddCard(c1)
	local att=c1:GetAttribute()
	mg=mg:Filter(c100228002.ntfilter,nil,att)
	local g2=Group.CreateGroup()
	for i=0,99 do
		local mg2=mg:Clone()
		local cg=mg2:Filter(aux.SynMixCheckRecursive,g2,tp,g2,mg2,i,1,99,c,g,smat)
		if cg:GetCount()==0 then break end
		local minct=1
		if aux.SynMixCheckGoal(tp,g2,1,i,c,g,smat) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=cg:Select(tp,minct,1,nil)
		if tg:GetCount()==0 then break end
		g2:Merge(tg)
	end
	g:Merge(g2)
	if g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c100228002.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c100228002.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TUNER)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and g:GetClassCount(Card.GetCode)>3
end
function c100228002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c100228002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e)) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c100228002.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100228002.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c100228002.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DRAGON)
end
function c100228002.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c100228002.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rg=Duel.GetDecktopGroup(tp,4)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,4,0,0)
end
function c100228002.operation2(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(tp,4)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
