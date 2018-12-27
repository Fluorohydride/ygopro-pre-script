--星杯の守護竜アルマドゥーク
--
--Script by mercury233
function c101008032.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101008032.ffilter,3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101008032.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c101008032.spcon)
	e2:SetTarget(c101008032.sptg)
	e2:SetOperation(c101008032.spop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101008032,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101008032.atkcon)
	e4:SetCost(c101008032.atkcost)
	e4:SetTarget(c101008032.atktg)
	e4:SetOperation(c101008032.atkop)
	c:RegisterEffect(e4)
end
function c101008032.ffilter(c)
	return c:IsFusionType(TYPE_LINK)
end
function c101008032.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c101008032.spfilter(c,fc)
	return c101008032.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c101008032.spcheck(g,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c101008032.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c101008032.spfilter,nil,c)
	return g:CheckSubGroup(c101008032.spcheck,3,3,tp)
end
function c101008032.sptg(e,tp,eg,ep,ev,re,r,rp,check,c)
	local g=Duel.GetReleaseGroup(tp):Filter(c101008032.spfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c101008032.spcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function c101008032.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	sg:DeleteGroup()
end
function c101008032.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsType(TYPE_LINK)
end
function c101008032.cfilter(c,lk)
	return c:IsType(TYPE_LINK) and c:GetLink()==lk and c:IsAbleToRemoveAsCost()
end
function c101008032.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(c101008032.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tc:GetLink()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101008032.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tc:GetLink())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101008032.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetBaseAttack())
end
function c101008032.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local dam=tc:GetBaseAttack()
	if tc:IsRelateToBattle() and tc:IsControler(1-tp) and Duel.Destroy(tc,REASON_EFFECT)~=0 and dam>0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
