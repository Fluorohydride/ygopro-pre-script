--The Tripping Mercury
--The Tripper Mercury
--Script by mercury233
function c100206006.initial_effect(c)
	--change position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c100206006.poscon)
	e1:SetTarget(c100206006.postg)
	e1:SetOperation(c100206006.posop)
	c:RegisterEffect(e1)
	--summon with 3 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100206006,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c100206006.ttcon)
	e2:SetOperation(c100206006.ttop)
	e2:SetValue(SUMMON_TYPE_ADVANCE+1)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c100206006.atkcon)
	e3:SetValue(c100206006.atkval)
	c:RegisterEffect(e3)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c100206006.posfilter(c)
	return c:IsDefencePos() or c:IsFacedown()
end
function c100206006.poscon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c100206006.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100206006.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c100206006.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100206006.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
function c100206006.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=3
end
function c100206006.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end
function c100206006.atkcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE+1
end
function c100206006.atkval(e,c)
	local rec=c:GetBaseAttack()
	if rec<0 then rec=0 end
	return rec*-1
end
